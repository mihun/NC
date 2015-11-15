package vector.container;

import vector.Vector;

import java.util.*;

/**
 * Created by Mihun on 11.11.2015.
 */
public class VectorMap<K, V extends Vector>  implements Map<K, V>{

    public VectorMap(int initialCapacity, int capacityIncrement) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal Capacity: "+
                    initialCapacity);
        this.data = (Pair<K, V>[])(new Pair[initialCapacity]);

        this.capacityIncrement = capacityIncrement;
    }

    public VectorMap(int initialCapacity) {
        this(initialCapacity, 0);
    }

    public VectorMap() {
        this(10);
    }

    public static class Pair<K, V extends Vector> implements Map.Entry<K, V> {
        private final K key;
        private V value;

        public Pair(K key, V value) {
            this.key = key;
            this.value = value;
        }

        @Override
        public K getKey() {
            return key;
        }

        @Override
        public V getValue() {
            return value;
        }

        @Override
        public V setValue(V value) {
            V old = this.value;
            this.value = value;
            return old;
        }
    }


    protected int size;
    protected int capacityIncrement;
    protected Pair<K, V>[] data;
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
    public V get(Object key) {
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
    public V put(K key, V value) {
        V oldValue;
        int index = indexOf(key);
        if (index >= 0){
            oldValue = data[index].getValue();
            data[index].setValue(value);
            return oldValue;
        }
        ensureCapacityHelper(size + 1);
        data[size++] = new Pair<K, V>(key, value);
        return null;
    }

    @Override
    public V remove(Object key) {
        int index = indexOf(key);
        if (index < 0)
            return null;
        V oldValue = data[index].getValue();
        int j = size - index - 1;
        if (j > 0) {
            System.arraycopy(data, index + 1, data, index, j);
        }
        size--;
        data[size] = null;
        return oldValue;
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> m) {
        for (K o : m.keySet()) {
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
    public Set<K> keySet() {
        Set<K> keys = new HashSet<K>();
        for (int i = 0; i < size(); i++) {
            keys.add(data[i].getKey());
        }
        return keys;
    }

    @Override
    public VectorCollection<V> values() {
        VectorCollection<V> vc = new VectorCollection<V>();
        for (int i = 0; i < size(); i++) {
            vc.add(data[i].getValue());
        }
        return vc;
    }

    @Override
    public Set<Map.Entry<K,V>> entrySet() {
        Set<Map.Entry<K,V>> entrySet = new HashSet<Map.Entry<K,V>>();
        for (int i = 0; i < size(); i++) {
            entrySet.add(data[i]);
        }
        return entrySet;
    }
}
