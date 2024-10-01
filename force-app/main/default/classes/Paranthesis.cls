public class Paranthesis {
    public boolean isValid(String par) {
        
		List<String> s = par.split('');
        List<String> st = new List<String>();
        
        for(Integer i = 0; i < s.size(); i++) {
            if(s[i] == '(' || s[i] == '{' || s[i] == '[') {
                st.add(s[i]);
            } else  {
                Integer size = st.size();
                if(size != 0 && s[i] == ')' && st[st.size()-1] == '(') {
                    st.remove(size-1); 
                } else if(size != 0 && s[i] == '}' && st[st.size()-1] == '{') {
                    st.remove(size-1);  
                } else if(size != 0 && s[i] == ']' && st[st.size()-1] == '[') {
                    st.remove(size-1); 
                } else {
                    return false;
                }
            }
        }
        
        if(st.isEmpty()) 
            return true;
        else
        	return false;
    }
}