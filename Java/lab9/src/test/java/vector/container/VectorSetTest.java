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
public class VectorSetTest {
    VectorSet<Vector> vs;

    @Before
    public void setUp() throws Exception {
        vs = new VectorSet<>(3);

    }

    @After
    public void tearDown() throws Exception {

    }

    @Test
    public void testAdd() throws Exception {
        assertTrue(vs.add(null));
        assertFalse(vs.add(null));
        Vector a = new ArrayVector(2);
        Vector b = new ArrayVector(1);
        assertTrue(vs.add(a));
        assertFalse(vs.add(a));
        assertFalse(vs.add(null));
        assertTrue(vs.add(b));
        assertArrayEquals(new Vector[]{null, a, b}, vs.elementData);
    }

    @Test
    public void testAddAll() throws Exception {
        Vector a = new ArrayVector(1);
        Vector b = new ArrayVector(2);
        Vector c = new ArrayVector(3);
        Vector d = new ArrayVector(4);
        Vector e = new ArrayVector(5);
        Collection<Vector> c1 = new VectorCollection<>(6);
        Collection<Vector> c2 = new VectorCollection<>(5);
        c1.add(a);
        c1.add(b);
        c1.add(c);
        c1.add(d);
        c1.add(e);
        c1.add(null);
        c2.add(a);
        c2.add(a);
        c2.add(b);
        c2.add(a);
        c2.add(null);
        c2.add(null);
        assertTrue(vs.addAll(c1));
        assertArrayEquals(new Vector[]{a, b, c, d, e, null}, vs.elementData);
        assertFalse(vs.addAll(c2));
    }
}