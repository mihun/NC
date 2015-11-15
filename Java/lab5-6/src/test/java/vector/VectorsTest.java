package vector;

import vector.impl.ArrayVector;
import vector.impl.LinkedVector;

import java.io.*;

import static org.junit.Assert.*;

/**
 * Created by Mihun on 12.11.2015.
 */
public class VectorsTest {


    public static void main(String[] args) {
        ArrayVector aVector = new ArrayVector(3);
        aVector.setElement(0, 2.3);
        aVector.setElement(1, 4.1);
        aVector.setElement(2, -7.9);

        ArrayVector aVectorOsTest = null;
        ArrayVector aVectorWrTest = null;
        ArrayVector aVectSerTest = null;

        System.out.println("current arrayVector");
        System.out.println(aVector);


        try (FileOutputStream fos = new FileOutputStream("C:\\test.txt");
             FileWriter fw = new FileWriter("C:\\test2.txt");
             FileOutputStream fileOutput = new FileOutputStream("C:\\test3.txt");
             ObjectOutputStream outputStream = new ObjectOutputStream(fileOutput))
        {
            Vectors.outputVector(aVector, fos);
            System.out.println("method outputVector complete");

            Vectors.writeVector(aVector, fw);
            System.out.println("method writeVector complete");

            outputStream.writeObject(aVector);
            System.out.println("Serialization complete");
        } catch (FileNotFoundException e) {
            System.err.println("Such file not found");
        } catch (IOException e) {
            System.err.println("Problem with stream");
        }


        try (FileInputStream fis = new FileInputStream("C:\\test.txt");
             FileReader fr = new FileReader("C:\\test2.txt");
             FileInputStream fiStream = new FileInputStream("C:\\test3.txt");
             ObjectInputStream objectStream = new ObjectInputStream(fiStream))
        {
            aVectorOsTest = (ArrayVector)Vectors.inputVector(fis);
            System.out.println("method inputVector complete");
            System.out.println("arrayVector from file:");
            System.out.println(aVectorOsTest);

            aVectorWrTest = (ArrayVector)Vectors.readVector(fr);
            System.out.println("method readVector complete");
            System.out.println("arrayVector from file:");
            System.out.println(aVectorWrTest);
            Object object = objectStream.readObject();
            aVectSerTest = (ArrayVector)object;
            System.out.println("Deserialization complete");
            System.out.println("arrayVector is:");
            System.out.println(aVectSerTest);

        } catch (FileNotFoundException e) {
            System.err.println("Such file not found");
        } catch (IOException e) {
            System.err.println("Problem with stream");
        } catch (ClassNotFoundException e) {
            System.err.println("Such class not found");
        }

        LinkedVector linkedVector = new LinkedVector(3);
        linkedVector.setElement(0, 5.4);
        linkedVector.setElement(1, 0.01);
        linkedVector.setElement(2, -2.2);
        System.out.println("current linkedVector vector");
        System.out.println(linkedVector);


        LinkedVector testVector = null;

        try (FileOutputStream fileOutput = new FileOutputStream("C:\\test4.txt");
             ObjectOutputStream outputStream = new ObjectOutputStream(fileOutput))
        {
            outputStream.writeObject(linkedVector);
            System.out.println("Serialization complete");
        } catch (FileNotFoundException e) {
            System.err.println("Such file not found");
        } catch (IOException e) {
            System.err.println("Problem with stream");
        }
        try (FileInputStream fiStream = new FileInputStream("C:\\test4.txt");
             ObjectInputStream objectStream = new ObjectInputStream(fiStream))
        {
            Object object = objectStream.readObject();
            testVector = (LinkedVector)object;
            System.out.println("Deserialization complete");
            System.out.println("linkedVector is:");
            System.out.println(testVector);

        } catch (FileNotFoundException e) {
            System.err.println("Such file not found");
        } catch (IOException e) {
            System.err.println("Problem with stream");
        } catch (ClassNotFoundException e) {
            System.err.println("Such class not found");
        }




    }
}

