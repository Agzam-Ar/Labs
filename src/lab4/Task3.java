package lab4;

import java.util.Scanner;

public class Task3 {

	// обратный код
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		long num = scanner.nextLong();
		int size = scanner.nextInt();
		scanner.close();
		if(size < 0 || 1 << (size-1) <= Math.abs(num)) {
			System.err.println("ошибка");
			return;
		}
		int bit = 0;
		if(num < 0) {
			bit = 1;
			num = -num;
		}
		System.out.print(bit);
		for (int i = size-2; i >= 0; i--) {
			System.out.print((num & (1L << i)) == 0 ? bit : (1-bit));
		}
	}
}
