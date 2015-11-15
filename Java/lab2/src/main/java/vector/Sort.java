package vector;

/**
 * Created by Mihun on 02.10.2015.
 */
public class Sort {
    public static Vector sort (Vector vect){
        for (int i = 0; i < vect.getLength(); i++){
            int min = i;
            for (int j = i+1; j < vect.getLength(); j++)
                if (vect.getValue(j) < vect.getValue(min))
                    min = j;

            double temp = vect.getValue(min);
            vect.setValue(min, vect.getValue(i));
            vect.setValue(i, temp);
        }
        return vect;
    }

}
