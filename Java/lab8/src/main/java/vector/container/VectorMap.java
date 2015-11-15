package vector.container;

import vector.Vector;

import java.util.*;

/**
 * Created by Mihun on 11.11.2015.
 */
public class VectorMap  implements Map{

    public VectorMap(int initialCapacity, int capacityIncrement) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal Capacity: "+
                    initialCapacity);
        this.data = new Pair[initialCapacity];
        this.capacityIncrement = capacityIncrement;
    }

    public VectorMap(int initialCapacity) {
        this(initialCapacity, 0);
    }

    public VectorMap() {
        this(10);
    }

    public static class Pair implements Map.Entry {
        private final Object key;
        private Vector value;

        public Pair(Object key, Vector value) {
            this.key = key;
            this.value = value;
        }

        @Override
        public Object getKey() {
            return key;
        }

        @Override
        public Vector getValue() {
            return value;
        }

        @Override
        public Vector setValue(Object value) {
            Vector old = this.value;
            this.value = (Vector)value;
            return old;
        }
    }


    protected int size;
    protected int capacityIncrement;
    protected Pair[] data;
    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean isEmpty() {
        return  size == 0;
    }

    @Override
    public boolean containsKey(Object key) {
        if (key == null) {
            for (int i = 0; i < size(); i++) {
                if (data[i].getKey() == null)
                    return true;
            }
        }
        else {
            for (int i = 0; i < size(); i++) {
                if (key.equals(data[i].getKey()))
                    return true;
            }
        }
        return false;
    }

    @Override
    public boolean containsValue(Object value) {
        if (value == null) {
            for (int i = 0; i < size(); i++) {
                if (data[i].getValue() == null)
                    return true;
            }
        }
        else {
            for (int i = 0; i < size(); i++) {
                if (value.equals(data[i].getValue()))
                    return true;
            }
        }
        return false;
    }

    @Override
    public Vector get(Object key) {
        if (key == null) {
            for (int i = 0; i < size(); i++) {
                if (data[i].getKey() == null)
                    return data[i].getValue();
            }
        }
        else {
            for (int i = 0; i < size(); i++) {
                if (key.equals(data[i].getKey()))
                    return data[i].getValue();
            }
        }
        return null;
    }

    private void ensureCapacityHelper(int minCapacity){
        if (minCapacity - data.length > 0)
            grow();
    }

    private void grow() {
        int oldCapacity = data.length;
        int newCapacity = oldCapacity + ((capacityIncrement > 0) ?
                capacityIncrement : oldCapacity);
        data = Arrays.copyOf(data, newCapacity);
    }
    private int indexOf(Object key){
        int index = -1;
        if (key == null){
            for (int i = 0; i < size; i++) {
                if (data[i].getKey() == null)
                    index = i;
            }
        } else {
            for (int i = 0; i < size; i++) {
                if (key.equals(data[i].getKey()))
                    index = i;
            }
        }
        return index;
    }
    @Override
    public Vector put(Object key, Object value) {
        Vector v = VectorCollection.getVectorFromObject(value);
        Vector oldValue;
        int index = indexOf(key);
        if (index >= 0){
            oldValue = data[index].getValue();
            data[index].setValue(value);
            return oldValue;
        }
        ensureCapacityHelper(size + 1);
        data[size++] = new Pair(key, v);
        return null;
    }

    @Override
    public Vector remove(Object key) {
        int index = indexOf(key);
        if (index < 0)
            return null;
        Vector oldValue = data[index].getValue();
        int j = size - index - 1;
        if (j > 0) {
            System.arraycopy(data, index + 1, data, index, j);
        }
        size--;
        data[size] = null;
        return oldValue;
    }

    @Override
    public void putAll(Map m) {
        for (Object o : m.keySet()) {
            this.put(o, m.get(o));
        }
    }

    @Override
    public void clear() {
        Pair[] pairs;
        if ((pairs = data) != null && size > 0) {
            size = 0;
            for (int i = 0; i < pairs.length; ++i)
                pairs[i] = null;
        }
    }

    @Override
    public Set keySet() {
        Set keys = new HashSet();
        for (int i = 0; i < size(); i++) {
            keys.add(data[i].getKey());
        }
        return keys;
    }

    @Override
    public VectorCollection values() {
        VectorCollection vc = new VectorCollection();
        for (int i = 0; i < size(); i++) {
            vc.add(data[i].getValue());
        }
        return vc;
    }

    @Override
    public Set entrySet() {
        Set entrySet = new HashSet();
        for (int i = 0; i < size(); i++) {
            entrySet.add(data[i]);
        }
        return entrySet;
    }
}
