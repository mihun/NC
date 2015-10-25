package vector;



/**
 * Created by Mihun on 02.10.2015.
 */
public class ArrayVector implements Vector{
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
        length = mass.length;
        for (int i = 0; i < length; i++) {
            vector[i] = mass[i];
        }
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
    public boolean equal(Vector vect){
        if (length != vect.getSize())
            return false;
        for (int i = 0; i < length; i++) {
            if (vector[i] != vect.getElement(i))
                return false;
        }
        return true;
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
        vector = ((ArrayVector)Vectors.sort(this)).vector;
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
            throw new IncompatibleVectorSizesException("Vectors sizes are not equal");
        for (int i = 0; i < length; i++) {
            vector[i] = vector[i] + vect.getElement(i);
        }

    }




}
