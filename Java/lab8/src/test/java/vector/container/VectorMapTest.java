package vector.container;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import vector.impl.ArrayVector;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

/**
 * Created by Mihun on 12.11.2015.
 */
public class VectorMapTest {
    VectorMap vm;
    VectorMap.Pair vp1 = new VectorMap.Pair("first", new ArrayVector(1));
    VectorMap.Pair vp2 = new VectorMap.Pair("second", null);
    VectorMap.Pair vp3 = new VectorMap.Pair(null, new ArrayVector(2));
    @Before
    public void setUp() throws Exception {
        vm = new VectorMap(3);
    }

    @After
    public void tearDown() throws Exception {

    }

    @Test
    public void testSize() throws Exception {
        assertEquals(0, vm.size());
        vm.size = 4;
        assertEquals(4, vm.size());
    }

    @Test
    public void testIsEmpty() throws Exception {
        assertTrue(vm.isEmpty());
        vm.size = 4;
        assertFalse(vm.isEmpty());
    }

    @Test
    public void testContainsKey() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        assertTrue(vm.containsKey(null));
        assertTrue(vm.containsKey("first"));
        assertTrue(vm.containsKey("second"));
        assertFalse(vm.containsKey("third"));
    }

    @Test
    public void testContainsValue() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        assertTrue(vm.containsValue(null));
        assertTrue(vm.containsValue(new ArrayVector(1)));
        assertTrue(vm.containsValue(new ArrayVector(2)));
        assertFalse(vm.containsValue(new ArrayVector(3)));
    }

    @Test
    public void testGet() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        assertEquals(new ArrayVector(2), vm.get(null));
        assertEquals(new ArrayVector(1), vm.get("first"));
        assertEquals(null, vm.get("second"));
        assertEquals(null, vm.get("third"));
    }

    @Test
    public void testPut() throws Exception {
        assertEquals(null, vm.put("first", new ArrayVector(1)));
        assertEquals(null, vm.put("second", null));
        assertEquals(null, vm.put(null, new ArrayVector(2)));
        assertEquals(3, vm.size);
        VectorMap.Pair[] p = new VectorMap.Pair[3];
        p[0] = new VectorMap.Pair("first", new ArrayVector(1));
        p[1] = new VectorMap.Pair("second", null);
        p[2] = new VectorMap.Pair(null, new ArrayVector(2));
        for (int i = 0; i < 3; i++) {
            assertEquals(p[i].getKey(), vm.data[i].getKey());
            assertEquals(p[i].getValue(), vm.data[i].getValue());
        }
        assertEquals(new ArrayVector(2), vm.put(null, new ArrayVector(3)));
        assertEquals(3, vm.size);
        p[2] = new VectorMap.Pair(null, new ArrayVector(3));
        for (int i = 0; i < 3; i++) {
            assertEquals(p[i].getKey(), vm.data[i].getKey());
            assertEquals(p[i].getValue(), vm.data[i].getValue());
        }
        assertEquals(new ArrayVector(1), vm.put("first", new ArrayVector(4)));
        assertEquals(3, vm.size);
        p[0] = new VectorMap.Pair("first", new ArrayVector(4));
        for (int i = 0; i < 3; i++) {
            assertEquals(p[i].getKey(), vm.data[i].getKey());
            assertEquals(p[i].getValue(), vm.data[i].getValue());
        }
    }

    @Test
    public void testRemove() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        assertEquals(null, vm.remove("third"));
        assertEquals(new ArrayVector(1), vm.remove("first"));
        assertEquals(2, vm.size);
        assertEquals(new ArrayVector(2), vm.remove(null));
        assertEquals(1, vm.size);
        assertEquals("second", vm.data[0].getKey());
        assertEquals(null, vm.data[0].getValue());


    }

    @Test
    public void testPutAll() throws Exception {
        vm.data[0] = new VectorMap.Pair(null, new ArrayVector(4));
        vm.size = 1;
        Map map = new HashMap();
        map.put("first", new ArrayVector(1));
        map.put("second", null);
        map.put(null, new ArrayVector(2));
        vm.putAll(map);
        assertEquals(3, vm.size);
    }

    @Test
    public void testClear() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        vm.clear();
        for (int i = 0; i < 3; i++) {
            assertEquals(null, vm.data[i]);
        }
        assertEquals(0, vm.size);


    }

    @Test
    public void testKeySet() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        Set set = vm.keySet();
        assertEquals(3, set.size());
        assertTrue(set.contains("first"));
        assertTrue(set.contains("second"));
        assertTrue(set.contains(null));

    }

    @Test
    public void testValues() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        VectorCollection vc = vm.values();
        assertEquals(3, vc.size());
        assertEquals(new ArrayVector(1), vc.elementData[0]);
        assertEquals(null, vc.elementData[1]);
        assertEquals(new ArrayVector(2), vc.elementData[2]);

    }

    @Test
    public void testEntrySet() throws Exception {
        vm.data[0] = vp1;
        vm.data[1] = vp2;
        vm.data[2] = vp3;
        vm.size = 3;
        Set set = vm.entrySet();
        assertEquals(3, set.size());
        assertTrue(set.contains(vp1));
        assertTrue(set.contains(vp2));
        assertTrue(set.contains(vp3));
    }
}