public class StringPractice {
  public static void demoMethods() {
    String str = 'Hello World';

    // Concatenation using the `+` operator
    System.debug(str + '!!!'); // Outputs: 'Hello World!!!'

    System.debug(str.contains('World')); // Outputs: true
    System.debug(str.charAt(0)); // Outputs: 'H'
    System.debug(str.equals('Hello World')); // Outputs: true
    System.debug(str.equalsIgnoreCase('hello world')); // Outputs: true
    System.debug(str.indexOf('o')); // Outputs: 4

    // isEmpty method usage
    // String emptyStr = '';
    // System.debug(emptyStr.isEmpty());                   // Outputs: true
    // System.debug(str.isEmpty());                        // Outputs: false

    System.debug(str.length()); // Outputs: 11
    System.debug(str.replace('World', 'Apex')); // Outputs: 'Hello Apex'

    List<String> parts = str.split(' ');
    System.debug(parts); // Outputs: (Hello, World)

    System.debug(str.startsWith('Hel')); // Outputs: true
    System.debug(str.substring(6)); // Outputs: 'World' (idx 6 to len)
    System.debug(str.toLowerCase()); // Outputs: 'hello world'
    System.debug(str.toUpperCase()); // Outputs: 'HELLO WORLD'
    System.debug(str.trim()); // Outputs: 'Hello World'   (removes spaces)
    System.debug(String.valueOf(100)); // Outputs: '100'  (casting)
  }
}