class CatalogDataTest{
  static final List<String> personsInsertionQuery = [
    'INSERT INTO Persons (id, userName, password, firstName1, lastName1, '
        'lastName2, birthDate) '
        'VALUES('
        '1, '
        '"alberto", '
        '"1234", '
        '"Alberto", '
        '"Moncada", '
        '"Gil", '
        '"19620424T000000")',
    'INSERT INTO Persons (id, userName, password, firstName1, firstName2, '
        'lastName1, lastName2, birthDate) '
        'VALUES('
        '2, '
        '"alejandro", '
        '"1234", '
        '"J", '
        '"Alejandro", '
        '"Marroquín", '
        '"Martínez", '
        '"19680101T000000")',
    'INSERT INTO Persons (id, userName, password, firstName1, firstName2, '
        'lastName1, lastName2, birthDate) '
        'VALUES('
        '3, '
        '"luis", '
        '"1234", '
        '"Luis", '
        '"Alberto", '
        '"Marroquín", '
        '"Martínez", '
        '"19820101T000000")',
    'INSERT INTO Persons  (id, userName, password, firstName1, lastName1, '
        'birthDate) '
        'VALUES('
        '4, '
        '"alfredo", '
        '"1234", '
        '"Alfredo", '
        '"Torres", '
        '"19820101T000000")',
  ];
}