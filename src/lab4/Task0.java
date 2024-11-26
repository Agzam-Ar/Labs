package lab4;

import java.util.Scanner;

public class Task0 {

	// обычное
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		long num = scanner.nextLong();
		int size = scanner.nextInt();
		scanner.close();
		if(num < 0 || size < 0) {
			System.err.println("ошибка");
			return;
		}
		for (int i = size-1; i >= 0; i--) {
			System.out.print((num & (1L << i)) == 0 ? 0 : 1);
		}
	}
}
