package vector;

import vector.impl.ArrayVector;

import java.io.*;

/**
 * Created by netcracker on 02.10.2015.
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
    public static void outputVector(Vector v, OutputStream out) throws IOException {
        DataOutputStream dataOut = new DataOutputStream(out);
        dataOut.writeInt(v.getSize());
        for (int i = 0; i < v.getSize(); i++) {
            dataOut.writeDouble(v.getElement(i));
        }
    }

    public static Vector inputVector(InputStream in) throws IOException {
        DataInputStream dataIn = new DataInputStream(in);
        int len = dataIn.readInt();
        ArrayVector aVect = new ArrayVector(len);
        for (int i = 0; i < aVect.getSize(); i++) {
            aVect.setElement(i, dataIn.readDouble());
        }
        return aVect;
    }

    public static void writeVector(Vector v, Writer out) throws IOException {
        out.write(v.getSize()+" " + v);

    }
    public static Vector readVector(Reader in) throws IOException {
        StreamTokenizer st = new StreamTokenizer(in);
        int len = 0;
        if (st.nextToken() == StreamTokenizer.TT_NUMBER)
            len = (int)st.nval;
        ArrayVector aVect = new ArrayVector(len);
        int i = 0;
        while(st.nextToken() == StreamTokenizer.TT_NUMBER) {
                    aVect.setElement(i, st.nval);
                    i++;
        }

        return aVect;
    }

}
