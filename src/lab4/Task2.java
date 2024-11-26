package lab4;

import java.util.Scanner;

public class Task2 {

	// дополнительный код
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		long num = scanner.nextLong();
		int size = scanner.nextInt();
		scanner.close();
		long c = (1 << (size-1));
		if(size < 0 || num < -c || num >= c) {
			System.err.println("ошибка");
			return;
		}
		num = (c ^ num) - c;
		for (int i = size-1; i >= 0; i--) {
			System.out.print((num & (1L << i)) == 0 ? 0 : 1);
		}
	}
}
