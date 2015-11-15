package vector;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by Mihun on 02.10.2015.
 */
public class VectorTest {
    Vector v;

    @Before
    public void setUp()  {
        v = new Vector(5);

    }

    @Test
    public void testGetValue()  {
        System.out.println("getValue");
        double res = 0.15;
        int index = 3;
        v.vector[index] = res;
        assertEquals(res, v.getValue(index), 0.0);
    }

    @Test
    public void testSetValue()  {
        System.out.println("setValue");
        double res = 0.25;
        int index = 2;
        v.setValue(index, res);
        assertEquals(res, v.vector[index], 0.0);
    }

    @Test
    public void testAddMass1()  {
        System.out.println("addMass with not equals length");
        double mass[] = new double[4];
        v.addMass(mass);


    }
    @Test
    public void testAddMass2()  {
        System.out.println("addMass");
        double mass[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        v.addMass(mass);
        for (int i = 0; i < 5; i++) {
            assertEquals(mass[i], v.vector[i], 0.0);
        }

    }



    @Test
    public void testAddVector()  {
        System.out.println("addVector");
        double mass[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        Vector vect = new Vector(5);
        vect.vector = mass;
        v.addVector(vect);
        for (int i = 0; i < 5; i++) {
            assertEquals(vect.vector[i], v.vector[i], 0.0);
        }

    }

    @Test
    public void testIsEquals1()  {
        System.out.println("isEquals with wrong length");
        Vector vect = new Vector(4);
        assertFalse(v.isEquals(vect));
    }

    @Test
    public void testIsEquals2()  {
        System.out.println("isEquals with wrong mass");
        Vector vect = new Vector(5);
        double mass1[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        double mass2[] = new double[]{0.1, 0.3, -0.5, 0.07, 0.4};
        vect.vector = mass1;
        v.vector = mass2;
        assertFalse(v.isEquals(vect));
    }
    @Test
    public void testIsEquals3()  {
        System.out.println("isEquals");
        Vector vect = new Vector(5);
        double mass1[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        double mass2[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        vect.vector = mass1;
        v.vector = mass2;
        assertTrue(v.isEquals(vect));
    }

    @Test
    public void testGetLength()  {
        System.out.println("getLength");
        int res = v.getLength();
        assertEquals(5, res);
    }

    @Test
    public void testMin()  {
        System.out.println("min");
        double mass[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        v.vector = mass;
        double res = v.min();
        assertEquals(-0.5, res, 0.0);
    }

    @Test
    public void testMax()  {
        System.out.println("min");
        double mass[] = new double[]{0.1, 0.3, -0.5, 0.07, 5.4};
        v.vector = mass;
        double res = v.max();
        assertEquals(5.4, res, 0.0);
    }

    @Test
    public void testSort()  {
        System.out.println("sort");
        double mass[] = new double[]{0.1, 0.3, -0.5, 5.4, 0.07};
        double sortedMass[] = new double[]{-0.5, 0.07, 0.1, 0.3, 5.4};
        v.vector = mass;
        v.sort();
        for (int i = 0; i < 5; i++) {
            assertEquals(mass[i], v.vector[i], 0.0);
        }

    }

    @Test
    public void testMultiply()  {
        System.out.println("multiply");
        double mass[] = new double[]{0.1, 0.3, -0.5, 5.4, 0.07};
        double expMass[] = new double[]{0.25, 0.75, -1.25, 13.5, 0.175};
        double koef = 2.5;
        v.vector = mass;
        v.multiply(koef);
        for (int i = 0; i < 5; i++) {
            assertEquals(expMass[i], v.vector[i], 0.0000000001);
        }
    }

    @Test
    public void testSum()  {
        System.out.println("sum");
        double mass[] = new double[]{0.1, 0.3, -0.5, 5.4, 0.07};
        double addMass[] = new double[]{0.25, -0.15, -0.25, -3.44, 0.17};
        double expMass[] = new double[]{0.35, 0.15, -0.75, 1.96, 0.24};
        v.vector = mass;
        Vector vect = new Vector(5);
        vect.vector = addMass;
        v.sum(vect);
        for (int i = 0; i < 5; i++) {
            assertEquals(expMass[i], v.vector[i], 0.0000000001);
        }
    }
}