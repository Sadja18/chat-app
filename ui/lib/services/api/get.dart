// HTTP request to get all users which matches the given username
Future<List<dynamic>> performUserSearch(String username) async {
  // Perform your search request to the backend here
  // Replace this with your actual API call or search logic
  await Future.delayed(Duration(seconds: 2)); // Simulating a delay

  // Return dummy search results
  return List.generate(10, (index) => 'Result $index for "$username"');
}
