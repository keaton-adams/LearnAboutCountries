![app icon](https://imgur.com/ozMnTwr.jpg)

# LearnAboutCountries
iOS app for learning about countries by leveraging publicly available data and AI.

# Details
This app uses the free GraphQL API at https://countries.trevorblades.com to get data about countries. It then uses this data to create two views - a list view and a detail view. Tapping on an item in the list takes you to the detail view, where you’ll see additional information about the country, including an AI summary and a fun fact. You can favorite the country via the star icon in the upper-right corner. It uses OpenAI’s GPT-3.5-Turbo as the LLM for AI generation.

# Setup
1. Clone the repository.
2. Create a `Secrets.xcconfig` with the following line:

   `OPENAI_API_KEY = "YOUR_OPENAI_API_KEY"`

3. Ensure you have the Apollo CLI installed to run the `fetch-data` and `generate` commands — you can find more information [here](https://www.apollographql.com/docs/ios/get-started).

# Architecture
* Uses an MVVM architecture pattern with dependency injection for both the API service and the LLM service, so either can be replaced in the future and to improve testability
* Has local data storage using `UserDefaults` to store the list of favorite countries
* Supports Dark Mode by using standard styles, fonts, and colors
* Supports accessibility by adding accessibility labels to UI elements

# Trade-offs
* Uses the auto-generated GraphQL models, which have the benefit of not needing to manually build custom data models and ensure the data models match the backend schema and those used on other platforms. However, they provide minimal client-side flexibility, require running the `fetch-data` and `generate` commands to stay up to date with the API, and add complexity for unit testing
* Uses `UserDefaults` for local storage, which is simple and easy to work with, but does not sync across devices and doesn’t provide conflict handling
* Uses `Secrets.xcconfig` for storing the LLM API key, which requires an additional configuration step by the developer

# Limitations
The main limitation of the initial implementation is time. Ideas for expansion and improvement include:
* Add unit tests and UI tests (happy path, no data, invalid data, proper error handling, etc.)
* Add more information about the country to the detail screen
* Add caching layers for the list and details
* Add the ability for users to ask a question about the country
* Add more styling and uniqueness to the UI
* Use type aliases for Apollo’s auto-generated models
* Expand error messages displayed to the user along with a retry mechanism
* Add support for using GitHub Secrets for LLM API key storage

# Screenshots
![list](https://imgur.com/g37RjdF.jpg)
![details](https://imgur.com/qKZZ9VF.jpg)
