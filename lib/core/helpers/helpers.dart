List<String> getAssetAndCondition(String condition) {
  switch (condition) {
    case "Clear":
      return ['assets/images/clear.png', 'clear'];
    case "Sunny":
      return ['assets/images/sunny.png', 'sunny'];
    case "Partly cloudy":
    case "Cloudy":
    case "Overcast":
      return ['assets/images/cloud.png', 'cloud'];
    case "Mist":
    case "Fog":
    case "Freezing fog":
      return ['assets/images/cloud.png', 'cloud'];
    case "Patchy rain possible":
    case "Patchy light drizzle":
    case "Light drizzle":
    case "Patchy light rain":
    case "Light rain":
    case "Moderate rain at times":
    case "Moderate rain":
    case "Heavy rain at times":
    case "Heavy rain":
    case "Light rain shower":
    case "Moderate or heavy rain shower":
    case "Torrential rain shower":
    case "Patchy light rain with thunder":
    case "Moderate or heavy rain with thunder":
      return ['assets/images/rain.png', 'rain'];
    case "Patchy snow possible":
    case "Patchy sleet possible":
    case "Patchy freezing drizzle possible":
    case "Light sleet":
    case "Moderate or heavy sleet":
    case "Light snow":
    case "Patchy light snow":
    case "Patchy moderate snow":
    case "Patchy heavy snow":
    case "Heavy snow":
    case "Moderate snow":
    case "Ice pellets":
    case "Light sleet showers":
    case "Moderate or heavy sleet showers":
    case "Light snow showers":
    case "Moderate or heavy snow showers":
    case "Light showers of ice pellets":
    case "Moderate or heavy showers of ice pellets":
    case "Patchy light snow with thunder":
    case "Moderate or heavy snow with thunder":
      return ['assets/images/snow.png', 'snow'];
    case "Thundery outbreaks possible":
    case "Blizzard":
    case "Blowing snow":
      return ['assets/images/snow.png', 'snow'];
    default:
      return ['assets/images/default.png', 'default'];
  }
}
