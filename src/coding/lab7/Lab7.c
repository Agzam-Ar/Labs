// Lab7.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "linkedlist.h"
#include "string.h"

#define bufferSize 20
#define vk_up 72
#define vk_down 80

typedef void listener(LinkedList* list, char*);

char* commands[] = { "append", "prepend", "remove","next", "previous", "help", "list", "clear" };
char* desc[] = { 
	"append <arg> element after current", 
	"prepend <arg> element before current", 
	"remove current element",
	"move index to next element", 
	"move index to previous element", 
	"show list of avalible commands",
	"show list elements", 
	"clearing all elements in list" 
};
int* arguments[] = { 1,1,0,0,0,0,0 };

void help(LinkedListNode* node, char* arg) {
	printf("Avalible commands:\n");
	for (int i = 0; i < sizeof(commands) / sizeof(char*); i++) {
		if (arguments[i]) printf("- %s <arg> \033[90m%s\033[0m\n", commands[i], desc[i]);
		else printf("- %s \033[90m%s\033[0m\n", commands[i], desc[i]);
	}
	printf("\n");
}

listener* listeners[] = { append,   prepend,  lremove,  next, previous, help, printList, clear };

int sizes[sizeof(commands) / sizeof(char*)];
char buffer[bufferSize];
int bufferIndex = 0;


void backCursor() {
	printf("%c", 8);
	printf(" ");
	printf("%c", 8);
	bufferIndex--;
}

int indexOfCmd() {
	for (int i = 0; i < sizeof(commands) / sizeof(char*); i++) {
		char* cmd = commands[i];
		char valid = 1;
		for (int x = 0; x < bufferIndex && x < sizes[i]; x++) {
			if (cmd[x] != buffer[x]) {
				valid = 0;
				break;
			}
		}
		if (valid) return i;
	}
	return -1;
}

int startsWithCmd() {
	for (int i = 0; i < sizeof(commands) / sizeof(char*); i++) {
		char* cmd = commands[i];
		char valid = 1;
		if (bufferIndex < sizes[i] - 1) continue;
		for (int x = 0; x < sizes[i] - 1; x++) {
			if (cmd[x] != buffer[x]) {
				valid = 0;
				break;
			}
		}
		if (valid) return i;
	}
	return -1;
}

void put(int key) {
	if (bufferIndex < bufferSize) {
		printf("%c", key);
		buffer[bufferIndex] = key;
		bufferIndex++;
	}
}

int main() {
	LinkedList* history = create();
	LinkedListNode* currentHistory = history->current;

	LinkedList* list = create();
	for (int i = 0; i < sizeof(commands) / sizeof(char*); i++) {
		for (sizes[i] = 0; commands[i][sizes[i]]; sizes[i]++);
	}
	printf("\033[34m>\033[0m");
	int mode = 0;
	while (1) {
		char key = _getch();
		if (mode == 1) {
			if (history->current != NULL && (key == vk_up || key == vk_down)) {
				while (bufferIndex > 0) backCursor();
				char* value = currentHistory->value;
				if (key == vk_up) currentHistory = currentHistory->prev;
				if (key == vk_down) currentHistory = currentHistory->next;
				for (int i = 0; 1; i++) {
					if (value[i] == '\0') break;
					put(value[i]);
				}
			}
			mode = 0;
			continue;
		}
		if (key == '\t') {
			int i = indexOfCmd();
			if (i != -1) {
				for (int x = bufferIndex; x < sizes[i]; x++) put(commands[i][x]);
				if (arguments[i]) put(' ');
			}
			continue;
		}
		if (key == 8 && bufferIndex > 0) {
			backCursor();
			continue;
		}
		if (key == 13 && bufferIndex > 0) {
			printf("\n");
			int ci = startsWithCmd();

			char* bufferCpy = malloc(sizeof(char) * (bufferIndex + 1));
			for (int i = 0; i < bufferIndex; i++) bufferCpy[i] = buffer[i];
			bufferCpy[bufferIndex] = '\0';

			if (ci == -1) {
				printf("\033[31mUnknown command\033[0m\n");
			}
			else {
				int argLength = (bufferIndex - sizes[ci] - 1);
				if (arguments[ci] && argLength <= 0) {
					printf("\033[31mCommand requires arguments\033[0m\n");
				}
				else if (!arguments[ci] && argLength >= 0) {
					printf("\033[31mToo many arguments\033[0m\n");
				}
				else {
					if (argLength > 0) {
						char* arg = malloc(sizeof(char) * (argLength + 1));
						for (int i = 0; i < argLength; i++) arg[i] = buffer[sizes[ci] + i + 1];
						arg[argLength] = '\0';
						printf("Executing command \033[92m%s\(\"%s\")\033[0m\n", commands[ci], arg);
						listeners[ci](list, arg);
					}
					else {
						printf("Executing command \033[92m%s()\033[0m\n", commands[ci]);
						listeners[ci](list, "");
					}
				}
			}
			append(history, bufferCpy);
			next(history, NULL);
			currentHistory = history->current;

			printf("\033[34m>\033[0m");
			bufferIndex = 0;
			continue;
		}
		if (('a' <= key && key <= 'z') || ('A' <= key && key <= 'Z') || ('0' <= key && key <= '9') || (key == ' ')) {
			put(key);
			continue;
		}
		if (key == -32) {
			mode = 1;
			continue;
		}
		//printf("%d", key);
	}
}

