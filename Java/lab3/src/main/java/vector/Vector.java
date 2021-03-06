package vector;

/**
 * Created by Mihun on 08.10.2015.
 */
public interface Vector {
    double getElement(int index);
    void setElement(int index, double value);
    int getSize();
    void fillFromMass(double[] mass);
    void fillFromVector(Vector vect);
    void mult(double koef);
    void sum(Vector vect) throws IncompatibleVectorSizesException;
    boolean equal(Vector vect);
}
