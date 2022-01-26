/// Substitutes all single quotes with double single quotes and removes all
/// semicolons. Every argument to query should be passed through this function.
///
/// The point of this function is to fail the SQL request and therefore prevent
/// SQL injection in case of malicious arguments supplied to query.
String prepareArgForQuery(String arg) {
  return arg.replaceAll("'", '').replaceAll(';', '').replaceAll('--', '');
}
