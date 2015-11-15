package vector.impl;

import vector.IncompatibleVectorSizesException;
import vector.Vector;
import vector.VectorIndexOutOfBoundsException;


import java.io.*;


/**
 * Created by Mihun on 14.10.2015.
 */
public class LinkedVector implements Vector, Cloneable, Serializable{
    public LinkedVector(int size) {
        for (int i=0;i<size;i++) {
            addElement(0.0);
        }
    }

    public LinkedVector() {
    }

    @Override
    public double getElement(int index) {
        if (index >= size)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        return goToElement(index).element;
    }

    @Override
    public void setElement(int index, double value) {
        if (index >= size)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        goToElement(index).element = value;
    }

    @Override
    public int getSize() {
        return size;
    }

    @Override
    public void fillFromMass(double[] mass) {
        head = new Nod(mass[0]);
//        size = mass.length;
        head.next = head;
        head.prev = head;
        Nod current = head;
        size = 1;
        if (mass.length > 1){
            int index = 1;
            while (index != mass.length){
                insertElementBefore(current, new Nod(mass[index]));
                index++;
            }
        }

    }

    @Override
    public void fillFromVector(Vector vect) {
        head = new Nod(vect.getElement(0));
        head.next = head;
        head.prev = head;
        Nod current = head;
        size = 1;
        if (vect.getSize() > 1){
            int index = 1;
            while (index != vect.getSize()){
                insertElementBefore(current, new Nod(vect.getElement(index)));
                index++;
            }
        }
    }


    @Override
    public void mult(double koef) {
        int index = 0;
        Nod current = head;
        while (index != size){
            current.element = koef*current.element;
            current = current.next;
            index++;
        }
    }

    @Override
    public void sum(Vector vect) throws IncompatibleVectorSizesException {
        if (size != vect.getSize())
            throw new IncompatibleVectorSizesException("Vectors sizes are not equal");
        int index = 0;
        Nod current = head;
        while (index != size){
            current.element += vect.getElement(index);
            current = current.next;
            index++;
        }
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Vector)) return false;
        Vector vect = (Vector) o;
        if (size != vect.getSize())
            return false;
        int index = 0;
        Nod current = head;
        while (index != size){
            if (current.element != vect.getElement(index))
                return false;
            current = current.next;
            index++;
        }

        return true;
    }

    @Override
    public int hashCode() {
        return 31 * size + (int) Math.round(head.element * 10 + 1);
    }

    @Override
    public String toString() {
        Nod current = head;
        StringBuilder sb = new StringBuilder(Double.toString(current.element));
        int index = 1;
        current = current.next;
        while (index != size){
            sb.append(" ").append(current.element);
            current = current.next;
            index++;
        }

        return sb.toString();
    }

    @Override
    public void addElement(double value) {
        if (head == null) {
            head = new Nod(value);
            head.prev = head;
            head.next = head;
            size = 1;
        }
        else{
            insertElementBefore(head, new Nod(value));
        }

    }

    @Override
    public void insertElement(double value, int index) {
        if (index == size) {
            addElement(value);
            return;
        }
        if (index > size)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");

        Nod curr = goToElement(index);
        Nod newNd = new Nod(value);
        insertElementBefore(curr, newNd);
        if (index == 0){
            head = head.prev;
        }

    }

    @Override
    public void deleteElement(int index) {
        if (index >= size)
            throw new VectorIndexOutOfBoundsException("index > size");
        if (index < 0)
            throw new VectorIndexOutOfBoundsException("index < 0");
        Nod curr = goToElement(index);
        delElement(curr);
    }

    public class Nod implements Serializable {
        public double element;
        public Nod next;
        public Nod prev;

        public Nod(double element) {
            this.element = element;
        }


    }

    protected Nod head;
    protected int size;

    protected Nod goToElement(int index) {
        Nod result = head;
        int i=0;
        while (i != index) {
            result = result.next;
            i++;
        }
        return result;
    }

    protected void insertElementBefore(Nod current, Nod newNod) {
        newNod.next = current;
        newNod.prev = current.prev;
        current.prev.next = newNod;
        current.prev = newNod;
        size++;
    }

    protected void delElement(Nod current) {
        if (size == 1) {
            head = null;
        } else {
            current.prev.next = current.next;
            current.next.prev = current.prev;
            if (current == head) {
                head = current.next;
            }
        }
        size--;

    }

    @Override
    public LinkedVector clone() throws CloneNotSupportedException {
        LinkedVector linkVectClone = (LinkedVector)super.clone();
        linkVectClone.fillFromVector(this);
        return linkVectClone;
    }


}
