package vector;

/**
 * Created by Mihun on 02.10.2015.
 */
public class Vector {
    protected int length;
    protected double[] vector;


    public Vector(int length) {
        this.length = length;
        vector = new double[length];
    }
    public double getValue(int i){
        return vector[i];
    }
    public void setValue(int i, double value){
        vector[i] = value;
    }

    public void addMass(double[] mass){
        vector = new double[mass.length];
        length = mass.length;
        for (int i = 0; i < length; i++) {
            vector[i] = mass[i];
        }
    }

    public void addVector(Vector vect){
        vector = new double[vect.getLength()];
        length = vect.getLength();
        for (int i = 0; i < length; i++) {
            vector[i] = vect.getValue(i);
        }
    }

    public boolean isEquals(Vector vect){
        if (length != vect.length)
            return false;
        for (int i = 0; i < length; i++) {
            if (vector[i] != vect.vector[i])
                return false;
        }
        return true;
    }

    public int getLength(){
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
        vector = Sort.sort(this).vector;
    }

    public void multiply(double k){
        for (int i = 0; i < length; i++) {
            vector[i] = vector[i]*k;
        }


    }

    public void sum(Vector vect){
        if (length != vect.getLength()) {
            System.err.println("Error! Lengths aren't equal");
            return;
        }

        for (int i = 0; i < length; i++) {
            vector[i] = vector[i] + vect.vector[i];
        }

    }




}
