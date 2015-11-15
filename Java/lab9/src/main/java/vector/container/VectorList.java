package vector.container;

import vector.Vector;
import vector.exception.VectorIndexOutOfBoundsException;

import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/**
 * Created by Mihun on 30.10.2015.
 */
public class VectorList<T extends Vector> extends VectorCollection<T> implements List<T>{

    public VectorList(int initialCapacity, int capacityIncrement) {
        super(initialCapacity, capacityIncrement);
    }

    public VectorList(int initialCapacity) {
        super(initialCapacity);
    }

    public VectorList() {
    }



    @Override
    public boolean addAll(int index, Collection<? extends T> c) {
        Object[] v = c.toArray();
        int numNew = v.length;
        ensureCapacityHelper(elementCount + numNew);
        int numMoved = elementCount - index;
        if (numMoved > 0)
            System.arraycopy(elementData, index, elementData, index + numNew,
                    numMoved);

        System.arraycopy(v, 0, elementData, index, numNew);
        elementCount += numNew;
        return numNew != 0;
    }


    private void rangeCheck(int index) {
        if (index < 0 || index >= elementCount)
            throw new VectorIndexOutOfBoundsException(index);
    }
    T elementData(int index) {
        return (T)elementData[index];
    }
    @Override
    public T get(int index) {
        rangeCheck(index);
        return elementData(index);
    }

    @Override
    public T set(int index, T element) {
        rangeCheck(index);
        T oldValue = elementData(index);
        elementData[index] = element;
        return oldValue;
    }

    @Override
    public void add(int index, T element) {
        rangeCheck(index);
        ensureCapacityHelper(elementCount + 1);
        System.arraycopy(elementData, index, elementData, index + 1,
                size() - index);
        elementData[index] = element;
        elementCount++;
    }

    @Override
    public T remove(int index) {
        rangeCheck(index);
        T oldValue = elementData(index);
        int numMoved = size() - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                    numMoved);
        elementData[--elementCount] = null;

        return oldValue;
    }

    @Override
    public int lastIndexOf(Object o) {

        if (o == null) {
            for (int i = elementCount-1; i >= 0; i--)
                if (elementData[i]==null)
                    return i;
        } else {
            for (int i = elementCount-1; i >= 0; i--)
                if (o.equals(elementData[i]))
                    return i;
        }
        return -1;

    }

    @Override
    public ListIterator listIterator() {
        throw new UnsupportedOperationException("Don't implemented yet");
    }

    @Override
    public ListIterator listIterator(int index) {
        throw new UnsupportedOperationException("Don't implemented yet");
    }

    @Override
    public List subList(int fromIndex, int toIndex) {
        if (fromIndex < 0)
            throw new IndexOutOfBoundsException("fromIndex = " + fromIndex);
        if (toIndex > elementCount)
            throw new IndexOutOfBoundsException("toIndex = " + toIndex);
        if (fromIndex > toIndex)
            throw new IllegalArgumentException("fromIndex(" + fromIndex +
                    ") > toIndex(" + toIndex + ")");

        List list = new VectorList(toIndex - fromIndex);
        for (int i = 0; i < (toIndex - fromIndex); i++) {
           list.add(elementData(fromIndex + i));
        }

        return list;
    }
}
