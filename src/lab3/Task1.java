package lab3;

import java.io.IOException;
import java.util.Scanner;

public class Task1 {

	public static void main(String[] args) throws IOException {
		Scanner scanner = new Scanner(System.in);
		long l = scanner.nextLong();
		scanner.close();
		long zeros = 1 - ((long)(l/0f) / Long.MAX_VALUE);
		boolean zero = true;
		for (int i = 63; i >= 0; i--) {
			if((l & (1L << i)) == 0) {
				if(!zero) zeros++;
			} else {
				zero = false;
			}
		}
		System.out.println(zeros);
	}
	
}
