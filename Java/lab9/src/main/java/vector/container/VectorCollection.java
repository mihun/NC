package vector.container;

import vector.Vector;
import vector.exception.VectorIndexOutOfBoundsException;

import java.util.*;

/**
 * Created by Mihun on 30.10.2015.
 */
public class VectorCollection<T extends Vector> implements Collection<T> {

    protected Vector[] elementData;
    protected int elementCount;
    protected int capacityIncrement;



    public VectorCollection(int initialCapacity, int capacityIncrement) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal Capacity: "+
                    initialCapacity);
        this.elementData = new Vector[initialCapacity];
        this.capacityIncrement = capacityIncrement;
    }

    public VectorCollection(int initialCapacity) {
        this(initialCapacity, 0);
    }

    public VectorCollection() {
        this(10);
    }



    @Override
    public int size() {
        return elementCount;
    }

    @Override
    public boolean isEmpty() {
        return elementCount == 0;
    }

    @Override
    public boolean contains(Object o) {
        return indexOf(o, 0) >= 0;
    }


    public int indexOf(Object o, int index) {
        if (o == null) {
            for (int i = index ; i < elementCount ; i++)
                if (elementData[i]==null)
                    return i;
        } else
            for (int i = index ; i < elementCount ; i++)
                if (o.equals(elementData[i]))
                    return i;

        return -1;
    }

    public int indexOf(Object o) {
        return indexOf(o, 0);
    }



    @Override
    public Iterator iterator() {
        throw new UnsupportedOperationException("Don't implemented yet");
    }

    @Override
    public Object[] toArray() {
        return Arrays.copyOf(elementData, elementCount);
    }



    @Override
    public boolean add(T o) {

        ensureCapacityHelper(elementCount + 1);
        elementData[elementCount++] = o;
        return true;

    }

    public void ensureCapacityHelper(int minCapacity) {
        if (minCapacity - elementData.length > 0)
            grow();
    }

    private void grow() {
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + ((capacityIncrement > 0) ?
                capacityIncrement : oldCapacity);
        elementData = Arrays.copyOf(elementData, newCapacity);
    }


    @Override
    public boolean remove(Object o) {
            return removeElement(o);
    }

    public void removeElementAt(int index) {
        if (index >= elementCount) {
            throw new VectorIndexOutOfBoundsException(index + " >= " +
                    elementCount);
        }
        else if (index < 0) {
            throw new VectorIndexOutOfBoundsException(index);
        }
        int j = elementCount - index - 1;
        if (j > 0) {
            System.arraycopy(elementData, index + 1, elementData, index, j);
        }
        elementCount--;
        elementData[elementCount] = null;
    }

    public  boolean removeElement(Object obj) {
        int i = indexOf(obj);
        if (i >= 0) {
            removeElementAt(i);
            return true;
        }
        return false;
    }


    @Override
    public boolean addAll(Collection<? extends T> c) {

        Object[] a = c.toArray();
        int numNew = a.length;
        ensureCapacityHelper(elementCount + numNew);
        System.arraycopy(a, 0, elementData, elementCount, numNew);
        elementCount += numNew;
        return numNew != 0;

    }

    @Override
    public void clear() {
        for (int i = 0; i < elementCount; i++)
            elementData[i] = null;

        elementCount = 0;
    }





    @Override
    public boolean retainAll(Collection<?> c) {
        Objects.requireNonNull(c);
        boolean modified = false;

        Object[] elementDataCopy = toArray();
        for (int i = 0; i < elementDataCopy.length; i++) {
            if (!c.contains(elementDataCopy[i])) {
                remove(elementDataCopy[i]);
                modified = true;
            }
        }
        return modified;
    }


    @Override
    public boolean removeAll(Collection<?> c) {
        Objects.requireNonNull(c);
        boolean modified = false;

        Object[] elementDataCopy = toArray();
        for (int i = 0; i < elementDataCopy.length; i++) {
            if (c.contains(elementDataCopy[i])) {
                remove(elementDataCopy[i]);
                modified = true;
            }
        }
        return modified;
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        Object[] massVectCol = c.toArray();
        for (int i = 0; i < massVectCol.length; i++) {
            if (!contains(massVectCol[i]))
                return false;
        }
        return true;
    }

    @Override
    public <T> T[] toArray(T[] a) {

        if (a.length < elementCount)
            return (T [])Arrays.copyOf(elementData, elementCount, a.getClass());

        System.arraycopy(elementData, 0, a, 0, elementCount);

        if (a.length > elementCount)
            a[elementCount] = null;

        return a;
    }
}
