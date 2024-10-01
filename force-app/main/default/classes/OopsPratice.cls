public class OopsPratice {
  public static Integer counter = 0;
  private static String name;
  private Integer age;
  public OopsPratice() {
    System.debug('==>  Object number ' + (++counter) + '\n');
  }

  public String getName() {
    return name;
  }

  public void setName(String newName) {
    name = newName;
  }

  // Getter for age
  public Integer getAge() {
    return age;
  }

  // Setter for age
  public void setAge(Integer newAge) {
    age = newAge;
  }
}