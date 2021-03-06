

using GLib;

/*
	Todo:
		- private / protected / internal
		- comments
		- parent
		- inheritance, interface impl
			- virtual, abstract, override
		- generics
*/


// global tests:
public delegate void test_delegate_global ();
public void test_function_global ();
public int test_field_global;
public const int test_const_global;


// Checked
public errordomain TestErrDomGlobal {
	ERROR1,
	ERROR2;

	public void method ();
	public static void static_method ();
}


// Checked
public enum TestEnumGlobal {
	ENVAL1 = 100,
	ENVAL2;

	public void method ();
	public static void static_method ();
}


// Checked
public class TestClassGlobal {
	public class InnerClass {
	}

	public struct InnerStruct {
	}

	public const int constant;
	public static int field1;
	public int field2;
	public TestClassGlobal ();
	public TestClassGlobal.named ();
	public void method ();
	public static void static_method ();
	public int property1 { get; set; }
	public int property2 { get; }
	public int property3 { owned get; construct set; }
	public delegate int Foo ();
	public signal int sig ();
}


// Checked
public interface TestInterfaceGlobal {
	public const int constant;
	public void method ();
	public static void static_method ();
	public int property1 { get; set; }
	public int property2 { get; }
	public int property3 { owned get; construct set; }
	public delegate int Foo ();
	public signal int sig ();
}


// Checked
public struct TestStructGlobal {
	public static int field1;
	public int field2;
	public TestStructGlobal ();
	public TestStructGlobal.named ();
	public void method ();
	public static void static_method ();
	public const int constant;
}


namespace ParamTest {
	public void test_function_param_1 ();
	public void test_function_param_2 (int a);
	public void test_function_param_3 (ref int a);
	public void test_function_param_4 (out int a);
	public void test_function_param_5 (owned Object o);
	public void test_function_param_6 (int? a);
	public void test_function_param_7 (...);
	public void test_function_param_8 (int a = 1);
	public void test_function_param_9 (int a, ref int b, out int c, owned Object d, int? e, int f = 1, ...);

	public void test_function_param_10 (int* a);
	public void test_function_param_11 (int** a);

	public void test_function_param_12 (int[] a);
	public void test_function_param_13 (int[,,] a);
	public void test_function_param_14 (int[][] a);
}


namespace ReturnTest {
	public void test_function_1 ();
	public int test_function_2 ();
	public int? test_function_3 ();
	public unowned string test_function_4 ();

	public int* test_function_5 ();
	public int** test_function_6 ();

	public int[] test_function_7 ();
	public int[,,] test_function_8 ();
	public int[][] test_function_9 ();
}




