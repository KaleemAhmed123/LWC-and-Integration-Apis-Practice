public class Formatter {
    public String changeTimeFormat(String timeStr) {
        List<String> st = timeStr.split(':');
        Integer hourInt = Integer.valueOf(st[0]);
        Integer minuteInt = Integer.valueOf(st[1]);
        
        String hourStr = (hourInt > 12) ? String.ValueOf(hourInt-12) : String.valueOf(hourInt);
        String minuteStr = String.valueOf(minuteInt);
        
        hourStr = hourInt < 10 ? '0' + hourStr: hourStr;
		minuteStr = minuteInt < 10 ? '0' + minuteStr: minuteStr;
        
        String ans = '    ';
        if(hourInt < 12) {
            if(hourInt == 0)
                ans += ('12' + ':' + minuteStr + ' AM');
            else     
            	ans += (hourStr + ':' + minuteStr + ' AM');
        } else {
            ans += (hourStr + ':' + minuteStr + ' PM');
        }
        
        return ans;
    }
}