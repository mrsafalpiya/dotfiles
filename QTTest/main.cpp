#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
	int foo = 10;

	QApplication a(argc, argv);
	MainWindow w;
	w.show();
	return a.exec();
}
