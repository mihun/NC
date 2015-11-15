package vector.container;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import vector.Vector;
import vector.impl.ArrayVector;

import java.util.Collection;

import static org.junit.Assert.*;

/**
 * Created by Mihun on 13.11.2015.
 */
public class VectorCollectionTest {
    VectorCollection<Vector> vc;
    @Before
    public void setUp() throws Exception {
        vc =new VectorCollection<>(5);
        vc.add(null);
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        vc.add(a);
        vc.add(null);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        vc.add(b);
        vc.add(a);
    }

    @After
    public void tearDown() throws Exception {

    }

    @Test
    public void testSize() throws Exception {
        int length1 = vc.size();
        assertEquals(5, length1);
        vc.elementCount = 6;
        int length2 = vc.size();
        assertEquals(6, length2);
    }

    @Test
    public void testIsEmpty() throws Exception {
        VectorCollection<Vector> vc2 = new VectorCollection<>(6);
        assertTrue(vc2.isEmpty());
    }

    @Test
    public void testContains() throws Exception {
        assertTrue(vc.contains(null));
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        assertTrue(vc.contains(a));
        Vector b = new ArrayVector(1);
        b.setElement(0, 22.1);
        assertFalse(vc.contains(b));
    }


    @Test (expected = UnsupportedOperationException.class)
    public void testIterator() throws Exception {
        vc.iterator();
    }

    @Test
    public void testToArray() throws Exception {
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Object[] result = vc.toArray();
        Vector[] v = new Vector[]{null, a, null, b, a};
        assertArrayEquals(v, result);
    }

    @Test
    public void testAdd() throws Exception {
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Vector[] v = new Vector[]{null, a, null, b, a};
        assertArrayEquals(v, vc.elementData);

    }

    @Test
    public void testRemove() throws Exception {
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        vc.remove(null);
        Vector[] v = new Vector[]{a, null, b, a, null};
        assertArrayEquals(v, vc.elementData);
        vc.remove(b);
        Vector[] v2 = new Vector[]{a, null, a, null, null};
        assertArrayEquals(v2, vc.elementData);
    }

    @Test
    public void testAddAll() throws Exception {
        Collection vc2 = new VectorCollection();

        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Vector a1 = new ArrayVector(1);
        a1.setElement(0, 7.3);
        Vector a2 = new ArrayVector(1);
        a2.setElement(0, 6.2);
        vc2.add(a1);
        vc2.add(null);
        vc2.add(a2);
        vc2.add(a2);
        vc2.add(null);
        vc.addAll(vc2);
        Vector[] v = new Vector[]{null, a, null, b, a, a1, null, a2, a2, null };
        assertArrayEquals(v, vc.elementData);
    }

    @Test
    public void testClear() throws Exception {
        vc.clear();
        assertArrayEquals(new Vector[]{null, null, null, null, null}, vc.elementData);
    }

    @Test
    public void testRetainAll() throws Exception {
        Collection vc2 = new VectorCollection();
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Vector a1 = new ArrayVector(1);
        a1.setElement(0, 7.3);
        Vector a2 = new ArrayVector(1);
        a2.setElement(0, 6.2);
        vc2.add(a);
        vc2.add(null);
        vc2.add(a2);
        vc.retainAll(vc2);
        assertArrayEquals(new Vector[]{null, a, null, a, null}, vc.elementData);


    }

    @Test
    public void testRemoveAll() throws Exception {
        Collection vc2 = new VectorCollection();
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Vector a1 = new ArrayVector(1);
        a1.setElement(0, 7.3);
        Vector a2 = new ArrayVector(1);
        a2.setElement(0, 6.2);
        vc2.add(a);
        vc2.add(null);
        vc2.add(a2);
        vc.removeAll(vc2);
        assertArrayEquals(new Vector[]{b, null, null, null, null}, vc.elementData);
    }

    @Test
    public void testContainsAll() throws Exception {
        Collection vc2 = new VectorCollection();
        Collection vc3 = new VectorCollection();
        Vector a = new ArrayVector(1);
        a.setElement(0, 3.3);
        Vector b = new ArrayVector(1);
        b.setElement(0, 1.1);
        Vector a1 = new ArrayVector(1);
        a1.setElement(0, 7.3);
        Vector a2 = new ArrayVector(1);
        a2.setElement(0, 6.2);
        vc2.add(a);
        vc2.add(null);
        vc3.add(a2);
        vc3.add(a);
        vc3.add(null);
        assertTrue(vc.containsAll(vc2));
        assertFalse(vc.containsAll(vc3));
    }


}