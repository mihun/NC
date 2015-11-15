package vector.impl;


import vector.IncompatibleVectorSizesException;
import vector.Vector;
import vector.VectorIndexOutOfBoundsException;
import vector.Vectors;



/**
 * Created by Mihun on 02.10.2015.
 */
public class ArrayVector implements Vector, Cloneable {
    protected int length;
    protected double[] vector;


    public double[] getVector() {
        return vector;
    }

    public ArrayVector(int length) {
        this.length = length;
        vector = new double[length];
    }
    @Override
    public double getElement(int i){
        if (i >= length)
            throw new VectorIndexOutOfBoundsException("index > size");
        else if (i < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        return vector[i];
    }
    @Override
    public void setElement(int i, double value){
        if (i >= length)
            throw new VectorIndexOutOfBoundsException("index > size");
        else if (i < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        vector[i] = value;
    }

    @Override
    public void fillFromMass(double[] mass) {
        vector = new double[mass.length];
        System.arraycopy(mass, 0, vector, 0, mass.length);
    }

    @Override
    public void fillFromVector(Vector vect)  {
        vector = new double[vect.getSize()];
        length = vect.getSize();
        for (int i = 0; i < length; i++) {
            vector[i] = vect.getElement(i);
        }
    }


    @Override
         public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Vector)) return false;
        Vector vect = (Vector) o;
        if (length != vect.getSize())
            return false;
        for (int i = 0; i < length; i++) {
            if (vector[i] != vect.getElement(i))
                return false;
        }
        return true;
    }

    @Override
    public int hashCode() {
        return 31*length + (int)Math.round(vector[0]*10 + 1);
    }



    @Override
    public void addElement(double value) {
        double temp[] = vector;
        length++;
        vector = new double[length];
        System.arraycopy(temp, 0, vector, 0, length-1);
        vector[length-1] = value;
    }

    @Override
    public void insertElement( double value, int index) {
        if (index == length) {
            addElement(value);
            return;
        }
        if (index >= length)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        double temp[] = vector;
        length++;
        vector = new double[length];
        System.arraycopy(temp, 0, vector, 0, index);
        vector[index] = value;
        System.arraycopy(temp, index, vector, index+1, length -1 - index);

    }

    @Override
    public void deleteElement(int index) {
        if (index >= length)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        double temp[] = vector;
        length--;
        vector = new double[length];
        System.arraycopy(temp, 0, vector, 0, index);
        System.arraycopy(temp, index+1, vector, index, length - index);

    }

    @Override
    public int getSize(){
        return length;
    }


    public double min(){
        double temp = vector[0];
        for (int i = 1; i < length; i++) {
            if (vector[i] < temp)
                temp = vector[i];
        }
        return temp;
    }

    public double max(){
        double temp = vector[0];
        for (int i = 1; i < length; i++) {
            if (vector[i] > temp)
                temp = vector[i];
        }
        return temp;
    }

    public void sort(){
        vector = ((ArrayVector) Vectors.sort(this)).vector;
    }
    @Override
    public void mult(double k){
        for (int i = 0; i < length; i++) {
            vector[i] = vector[i]*k;
        }


    }
    @Override
    public void sum(Vector vect) throws IncompatibleVectorSizesException {
        if (length != vect.getSize())
            throw new IncompatibleVectorSizesException("Vectors sizes are not equals");
        for (int i = 0; i < length; i++) {
            vector[i] = vector[i] + ((ArrayVector)vect).vector[i];
        }

    }




    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(Double.toString(vector[0]));
        for (int i = 1; i < length; i++) {
            sb.append(" ").append(vector[i]);
        }
        return sb.toString();

    }

    @Override
    public ArrayVector clone() throws CloneNotSupportedException {
        ArrayVector arrVectClone = (ArrayVector)super.clone();
        arrVectClone.vector = vector.clone();
        return arrVectClone;
    }
}
