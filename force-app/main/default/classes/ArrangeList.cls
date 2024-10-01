public class ArrangeList {
    public void arrangeAlternately(List<Integer> inputList) {
        List<Integer> positiveList = new List<Integer>();
        List<Integer> negativeList = new List<Integer>();
        
        for (Integer num : inputList) {
            if (num >= 0) {
                positiveList.add(num);
            } else {
                negativeList.add(num);
            }
        }

        List<Integer> resultList = new List<Integer>();
        Integer posIndex = 0;
        Integer negIndex = 0;
        
        while (posIndex < positiveList.size() && negIndex < negativeList.size()) {
            resultList.add(positiveList[posIndex]);
            resultList.add(negativeList[negIndex]);
            posIndex++;
            negIndex++;
        }

        // Add any remaining elements
        while (posIndex < positiveList.size()) {
            resultList.add(positiveList[posIndex]);
            posIndex++;
        }

        while (negIndex < negativeList.size()) {
            resultList.add(negativeList[negIndex]);
            negIndex++;
        }
        
        System.debug(resultList);

    }
}