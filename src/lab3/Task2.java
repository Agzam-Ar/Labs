package lab3;

import java.io.IOException;
import java.util.Scanner;

public class Task2 {

	public static void main(String[] args) throws IOException {
		Scanner scanner = new Scanner(System.in);
		long l = scanner.nextLong();
		int index = scanner.nextInt();
		scanner.close();
		System.out.println((l & (1L << index)) == 0 ? 0 : 1);
	}
	
}
