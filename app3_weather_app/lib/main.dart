import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main(List<String> args) {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

enum City {
  stalkholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stalkholm: "❄️",
      City.paris: "🌧️",
      City.tokyo: "💨",
    }[city]!,
  );
}

//will be changed by the UI
//UI writes to and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unKnownWeatherEmoji = '🤷‍♂️';

//UI reads this
final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getWeather(city);
    } else {
      return unKnownWeatherEmoji;
    }
  },
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data,
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            error: (_, __) => const Text('Error 🥲'),
            loading: () => const Padding(
              padding: EdgeInsets.all(13.5),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(
                    city.toString(),
                  ),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => ref
                      .read(
                        currentCityProvider.notifier,
                      )
                      .state = city,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
