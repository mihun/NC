package vector.container;

import vector.Vector;

import java.util.Collection;
import java.util.Set;

/**
 * Created by Mihun on 11.11.2015.
 */
public class VectorSet<T extends Vector> extends VectorCollection<T> implements Set<T> {
    @Override
    public boolean add(T o) {
        if (!contains(o))
            return super.add(o);
        return false;
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        Object[] mass = c.toArray();
        int modified = 0;
        for (int i = 0; i < mass.length; i++) {
            if (add((T)mass[i]))
                modified++;
        }
        return modified > 0;
    }

    public VectorSet(int initialCapacity, int capacityIncrement) {
        super(initialCapacity, capacityIncrement);
    }

    public VectorSet(int initialCapacity) {
        super(initialCapacity);
    }

    public VectorSet() {
    }


}
