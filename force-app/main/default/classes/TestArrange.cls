public class TestArrange {
    public static void testArrangeAlternately() {
        ArrangeList arrangeList = new ArrangeList();
        
        List<Integer> testList = new List<Integer>{3, -1, 2, -5, -2, 6, -3};
        List<Integer> resultList = arrangeList.arrangeAlternately(testList);

        System.debug('Original List: ' + testList);
        System.debug('Arranged List: ' + resultList);
    }
}