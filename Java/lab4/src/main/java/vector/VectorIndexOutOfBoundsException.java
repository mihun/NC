package vector;

/**
 * Created by Mihun on 08.10.2015.
 */
public class VectorIndexOutOfBoundsException extends IndexOutOfBoundsException {
    public VectorIndexOutOfBoundsException(String s) {
        super(s);
    }
    public VectorIndexOutOfBoundsException() {
        super();
    }
    public VectorIndexOutOfBoundsException(int index) {
        super("Array index out of range: " + index);
    }
}
