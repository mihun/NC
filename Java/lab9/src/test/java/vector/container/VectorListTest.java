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
public class VectorListTest {
    VectorList<Vector> vl;
    Vector a;
    Vector b;
    Vector c;

    @Before
    public void setUp() throws Exception {
        vl = new VectorList<>(5);
        vl.add(null);
        a = new ArrayVector(1);
        a.setElement(0, 3.3);
        vl.add(a);
        vl.add(null);
        b = new ArrayVector(1);
        b.setElement(0, 1.1);
        vl.add(b);
        vl.add(a);
        c = new ArrayVector(1);
        c.setElement(0, 7.7);

    }

    @After
    public void tearDown() throws Exception {

    }
    @Test
    public void testAddAll() throws Exception {
        Collection<Vector> col = new VectorList<>(3);
        col.add(a);
        col.add(null);
        col.add(c);
        vl.addAll(1, col);
        assertArrayEquals(new Vector[]{null, a, null, c, a, null, b, a, null, null}, vl.elementData);
    }


    @Test
    public void testGet() throws Exception {
        Vector result = vl.get(1);
        assertEquals(a, result);
        Vector result2 = vl.get(2);
        assertEquals(null , result2);
    }

    @Test
    public void testSet() throws Exception {
        vl.set(2, c);
        assertEquals(c , vl.elementData[2]);
    }

    @Test
    public void testAdd() throws Exception {
        vl.add(2, c);
        assertArrayEquals(new Vector[]{null, a, c, null, b, a, null, null, null, null}, vl.elementData);
    }

    @Test
    public void testRemove() throws Exception {
        vl.remove(c);
        assertArrayEquals(new Vector[]{null, a, null, b, a}, vl.elementData);
        vl.remove(null);
        assertArrayEquals( new Vector[]{ a, null, b, a, null}, vl.elementData);
        vl.remove(b);
        assertArrayEquals( new Vector[]{ a, null, a, null, null}, vl.elementData);
    }

    @Test
    public void testLastIndexOf() throws Exception {
        int result = vl.lastIndexOf(a);
        assertEquals(4, result);


    }

    @Test (expected = UnsupportedOperationException.class)
    public void testListIterator() throws Exception {
        vl.listIterator();
    }

    @Test (expected = UnsupportedOperationException.class)
    public void testListIterator1() throws Exception {
        vl.listIterator(1);

    }

    @Test
    public void testSubList() throws Exception {
        VectorList vl2 = (VectorList)vl.subList(1,3);
        assertArrayEquals( new Vector[]{a, null}, vl2.elementData);
    }
}