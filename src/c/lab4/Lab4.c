/*
N -натуральных чисел являются элементами двунаправленного списка L, вычислить: X1*Xn+X2*Xn-1+...+Xn*X1.
Вывести на экран каждое произведение и итоговую сумму.
*/
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

typedef struct Node Node;

struct Node {
	int value;
	Node* next;
	Node* prev;
};

Node buffer[1000];

void printBuffer(Node* from) {
	Node* n = from;
	while(1) {
		//printf("%d ", n->value);
		printf("%d ",n->value);
		//printf("[%d,%d,%d]", buffer[n.prev].value, n.value, buffer[n.next].value);
		n = n->next;
		if (n == from) break;
	}
	printf("\n");
}


int main() {
	int n = 10;
	printf("Enter seq size:\n");
	scanf("%d", &n);
	printf("Enter seq elements:\n");
	Node tmp = buffer[0];
	tmp.value = 0;
	Node* current = &tmp;
	scanf("%d", &current->value);
	current->next = &tmp;
	current->prev = &tmp;
	printf("Current seq: ");
	printBuffer(current);
	for (int i = 1; i < n; i++) {
		Node* insert = &buffer[i];
		scanf("%d", &insert->value);
		insert->next = current->next;
		current->next = insert;
		insert->prev = current;
		printf("Current seq: ");
		printBuffer(current);
		current = insert;
	}
	tmp.prev = current;

	// logic

	int sum = 0;
	Node* a = &tmp;
	Node* b = (&tmp)->prev;
	while (1) {
		sum += a->value * b->value;
		printf("%d*%d\n", a->value, b->value);
		if (b == &tmp) break;
		a = a->next;
		b = b->prev;
	}
	printf("SUM: %d\n", sum);
}

