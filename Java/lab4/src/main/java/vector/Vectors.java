package vector;

/**
 * Created by Mihun on 02.10.2015.
 */
public class Vectors {
    public static Vector sort (Vector vect){
        for (int i = 0; i < vect.getSize(); i++){
            int min = i;
            for (int j = i+1; j < vect.getSize(); j++)
                if (vect.getElement(j) < vect.getElement(min))
                    min = j;

            double temp = vect.getElement(min);
            vect.setElement(min, vect.getElement(i));
            vect.setElement(i, temp);
        }
        return vect;
    }

}
