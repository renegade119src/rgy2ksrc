{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}

{ Waiting For Call screen }

unit wfcmenu;

interface

uses crt, dos, overlay, common, myio, timefunc, dfFix;

procedure wfcmdefine;
procedure wfcmenus;

implementation

uses boot,  sysop1, sysop2, sysop3, sysop4, User,
     sysop6,  sysop7, sysop8, sysop9, sysop10, sysop11,
     mail0, mail1, Email, mail5, mail6, mail7, Event,
     arcview, file0, file1, file2, file5, file6, file8,
     file9, file10, file11, file13, archive1, archive2,
     Bulletin, cuser, doors, menus2, msgpack,
     multnode, Maint;

var
  LastKeyPress:longint;

const
  ANSWER_LENGTH=203;
  ANSWER : array [1..203] of Char = (
    #0 ,#17,#25,#23,#14,'R','e','n','e','g','a','d','e',' ','i','s',' ',
    'a','n','s','w','e','r','i','n','g',' ','t','h','e',' ','p','h','o',
    'n','e','.',#25,#19,#24,#25,'K',#24,' ',' ',#15,'[',#14,'A',#15,']',
    ' ',' ','3','0','0',#25,#3 ,'[',#14,'C',#15,']',' ','2','4','0','0',
    #25,#3 ,'[',#14,'E',#15,']',' ','7','2','0','0',#25,#3 ,'[',#14,'G',
    #15,']',' ','1','2','0','0','0',#25,#3 ,'[',#14,'I',#15,']',' ','1',
    '6','8','0','0',#25,#3 ,'[',#14,'K',#15,']',' ','3','8','4','0','0',
    #25,#2 ,#24,' ',' ','[',#14,'B',#15,']',' ','1','2','0','0',#25,#3 ,
    '[',#14,'D',#15,']',' ','4','8','0','0',#25,#3 ,'[',#14,'F',#15,']',
    ' ','9','6','0','0',#25,#3 ,'[',#14,'H',#15,']',' ','1','4','4','0',
    '0',#25,#3 ,'[',#14,'J',#15,']',' ','1','9','2','0','0',#25,#3 ,'[',
    #14,'L',#15,']',' ','5','7','6','0','0',#25,#2 ,#24,#25,'K',#24);

  WFCNET_LENGTH=98;
  WFCNET : array [1..98] of Char = (
    #0 ,#17,#25,'K',#24,#25,#26,#15,'R','e','n','e','g','a','d','e',' ',
    'N','e','t','w','o','r','k',' ','N','o','d','e',#25,#27,#24,#25,'K',
    #24,#25,#9 ,'P','r','e','s','s',' ','[','S','P','A','C','E','B','A',
    'R',']',' ','t','o',' ','l','o','g','i','n','.',' ',' ','P','r','e',
    's','s',' ','[','Q',']',' ','t','o',' ','q','u','i','t',' ','R','e',
    'n','e','g','a','d','e','.',#25,#10,#24,#25,'K',#24);

  WFCNODE_LENGTH=235;
  WFCNODE : array [1..235] of Char = (
     #0,#16,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#24,#17,' ','?',#26,#19,'?', #9,'?',' ', #0,'?',#26,'4','?', #9,
    '?',' ',#24,' ', #0,'?',' ', #5,'?',#15,'N','o','d','e','s',' ','U',
    's','e','d',#25, #7, #9,'?',' ', #0,'?',' ', #8,#26,'2','?',' ', #9,
    '?',' ',#24,' ', #0,'?',' ', #9,'?',#15,'D','o','o','r','s',' ','O',
    'p','e','n',#25, #7, #9,'?',' ', #0,'?',' ', #8,#26,'2','?',' ', #9,
    '?',' ',#24,' ', #0,'?',' ',#14,'?',#15,'N','U',' ','O','n','l','i',
    'n','e',#25, #8, #9,'?',' ', #0,'?',' ', #8,#26,'2','?',' ', #9,'?',
    ' ',#24,' ', #0,'?',' ',#12,#27,'?',#15,#27,'N','o','d','e','s',' ',
    'E','r','r','o','r',#25, #6, #9,'?',' ', #0,'?',' ', #8,#26,'2','?',
    ' ', #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'V',#15,']','e','i',
    'w',' ','N','o','d','e',' ','E','r','r','o','r','s',' ', #9,'?',' ',
     #0,'?',' ', #8,#26,'2','?',' ', #9,'?',' ',#24,' ', #0,'?', #9,#26,
    #19,'?','?',' ', #0,'?', #9,#26,'4','?','?',' ',#24,#24);

  WFC_LENGTH=1153;
  WFC : array [1..1153] of Char = (
    #15,#17,#25,#22,'T','h','e',' ','R','e','n','e','g','a','d','e',' ',
    'B','u','l','l','e','t','i','n',' ','B','o','a','r','d',' ','S','y',
    's','t','e','m',#25,#22,#24,' ', #0,'?',#26,#16,'?', #9,'?',' ', #0,
    '?',#26,#16,'?', #9,'?',' ', #0,'?',#26,#16,'?', #9,'?',' ', #0,'?',
    #26,#15,'?', #9,'?',' ',#24,' ', #0,'?',' ',' ',#10,'T','o','d','a',
    'y',#39,'s',' ','S','t','a','t','s',' ',' ', #9,'?',' ', #0,'?',' ',
    #10,'S','y','s','t','e','m',' ','A','v','e','r','a','g','e','s',' ',
     #9,'?',' ', #0,'?',' ',' ',#10,'S','y','s','t','e','m',' ','T','o',
    't','a','l','s',' ',' ', #9,'?',' ', #0,'?',#25, #2,#10,'O','t','h',
    'e','r',' ','I','n','f','o',#25, #2, #9,'?',' ',#24,' ', #0,'?',' ',
    #15,'C','a','l','l','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'C','a',
    'l','l','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'C','a','l','l','s',
    #25,#10, #9,'?',' ', #0,'?',' ',#15,'N','o','d','e',#25,#10, #9,'?',
    ' ',#24,' ', #0,'?',' ',#15,'P','o','s','t','s',#25,#10, #9,'?',' ',
     #0,'?',' ',#15,'P','o','s','t','s',#25,#10, #9,'?',' ', #0,'?',' ',
    #15,'P','o','s','t','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'U','n',
    'd','e','r',#25, #9, #9,'?',' ',#24,' ', #0,'?',' ',#15,'E','m','a',
    'i','l',#25,#10, #9,'?',' ', #0,'?',' ',#15,'#',' ','U','L',#25,#11,
     #9,'?',' ', #0,'?',' ',#15,'#',' ','U','L',#25,#11, #9,'?',' ', #0,
    '?',' ',#15,'E','r','r','o','r','s',#25, #8, #9,'?',' ',#24,' ', #0,
    '?',' ',#15,'N','e','w','u','s','e','r','s',#25, #7, #9,'?',' ', #0,
    '?',' ',#15,'#',' ','D','L',#25,#11, #9,'?',' ', #0,'?',' ',#15,'#',
    ' ','D','L',#25,#11, #9,'?',' ', #0,'?',' ',#15,'M','a','i','l',#25,
    #10, #9,'?',' ',#24,' ', #0,'?',' ',#15,'F','e','e','d','b','a','c',
    'k',#25, #7, #9,'?',' ', #0,'?',' ',#15,'A','c','t','i','v','i','t',
    'y',#25, #7, #9,'?',' ', #0,'?',' ',#15,'D','a','y','s',#25,#11, #9,
    '?',' ', #0,'?',' ',#15,'U','s','e','r','s',#25, #9, #9,'?',' ',#24,
    ' ', #0,'?',' ',#15,'#',' ','U','L',#25,#11, #9,'?',' ', #0,'?', #9,
    #26,#16,'?','?',' ', #0,'?', #9,#26,#16,'?','?',' ', #0,'?', #9,#26,
    #15,'?','?',' ',#24,' ', #0,'?',' ',#15,'K','b',' ','U','L',#25,#10,
     #9,'?',' ', #0,'?',#26,#23,'?',' ',#15,'M','o','d','e','m',' ', #0,
    #26,#24,'?', #9,'?',' ',#24,' ', #0,'?',' ',#15,'#',' ','D','L',#25,
    #11, #9,'?',' ', #0,'?',#16,#25,'7', #9,#17,'?',' ',#24,' ', #0,'?',
    ' ',#15,'K','b',' ','D','L',#25,#10, #9,'?',' ', #0,'?',#16,#25,'7',
     #9,#17,'?',' ',#24,' ', #0,'?',' ',#15,'M','i','n','u','t','e','s',
    #25, #8, #9,'?',' ', #0,'?',#16,#25,'7', #9,#17,'?',' ',#24,' ', #0,
    '?',' ',#15,'O','v','e','r','l','a','y','s',#25, #7, #9,'?',' ', #0,
    '?',#16,#25,'7', #9,#17,'?',' ',#24,' ', #0,'?',' ',#15,'M','e','g',
    's',' ','F','r','e','e',#25, #6, #9,'?',' ', #0,'?',#16,#25,'7', #9,
    #17,'?',' ',#24,' ', #0,'?', #9,#26,#16,'?','?',' ', #0,'?', #9,#26,
    '7','?','?',' ',#24,#25,'O',#24,' ', #0,'?',#26,'K','?', #9,'?',' ',
    #24,' ', #0,'?',' ',#15,'[',#14,'S',#15,']','y','s','t','e','m',' ',
    'C','o','n','f','i','g',' ','[',#14,'F',#15,']','i','l','e',' ','B',
    'a','s','e',#25, #3,'[',#14,'C',#15,']','a','l','l','e','r','s',#25,
     #3,'[',#14,'I',#15,']','n','i','t',' ','M','o','d','e','m',#25, #3,
    '[',#14,'!',#15,']','V','a','l','i','d','a','t','e',#25, #3, #9,'?',
    ' ',#24,' ', #0,'?',' ',#15,'[',#14,'U',#15,']','s','e','r',' ','E',
    'd','i','t','o','r',#25, #2,'[',#14,'B',#15,']','M','s','g',' ','B',
    'a','s','e',#25, #3,'[',#14,'P',#15,']','a','c','k',' ','M','s','g',
    's',' ',' ','[',#14,'O',#15,']','f','f','h','o','o','k',' ','M','o',
    'd','e','m',' ','[',#14,'L',#15,']','o','g','s',#25, #8, #9,'?',' ',
    #24,' ', #0,'?',' ',#15,'[',#14,'#',#15,']','M','e','n','u',' ','E',
    'd','i','t','o','r',' ',' ','[',#14,'X',#15,']','f','e','r',' ','P',
    'r','o','t','s',#25, #2,'[',#14,'M',#15,']','a','i','l',' ','R','e',
    'a','d',' ',' ','[',#14,'A',#15,']','n','s','w','e','r',' ','M','o',
    'd','e','m',' ',' ','[',#14,'Z',#15,']','H','i','s','t','o','r','y',
    #25, #4, #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'E',#15,']','v',
    'e','n','t',' ','E','d','i','t','o','r',' ',' ','[',#14,'W',#15,']',
    'r','i','t','e',' ','M','a','i','l',#25, #2,'[',#14,'R',#15,']','e',
    'a','d',' ','M','a','i','l',' ',' ','[',#14,'H',#15,']','a','n','g',
    'u','p',' ','M','o','d','e','m',' ',' ','[',#14,'D',#15,']','r','o',
    'p',' ','t','o',' ','D','O','S',' ',' ', #9,'?',' ',#24,' ', #0,'?',
    ' ',#15,'[',#14,'V',#15,']','o','t','i','n','g',' ','E','d','i','t',
    'o','r',' ','[',#14,'$',#15,']','C','o','n','f','e','r','e','n','c',
    'e','s',' ','[',' ',']',' ','L','o','g',' ','O','n',#25, #2,'[',#14,
    'N',#15,']','o','d','e',' ','l','i','s','t','i','n','g',' ',' ','[',
    #14,'Q',#15,']','u','i','t',' ','t','o',' ','D','o','s',' ',' ', #9,
    '?',' ',#24,' ', #0,'?', #9,#26,'K','?','?',' ',#24,#24);

 {WFC_LENGTH=1211;
  WFC : array [1..1211] of Char = (
    #15,#17,#25,#22,'T','h','e',' ','R','e','n','e','g','a','d','e',' ',
    'B','u','l','l','e','t','i','n',' ','B','o','a','r','d',' ','S','y',
    's','t','e','m',#25,#22,#24,' ', #0,'?',#26,#16,'?', #9,'?',' ', #0,
    '?',#26,#16,'?', #9,'?',' ', #0,'?',#26,#16,'?', #9,'?',' ', #0,'?',
    #26,#15,'?', #9,'?',' ',#24,' ', #0,'?',' ',' ',#10,'T','o','d','a',
    'y',#39,'s',' ','S','t','a','t','s',' ',' ', #9,'?',' ', #0,'?',' ',
    #10,'S','y','s','t','e','m',' ','A','v','e','r','a','g','e','s',' ',
     #9,'?',' ', #0,'?',' ',' ',#10,'S','y','s','t','e','m',' ','T','o',
    't','a','l','s',' ',' ', #9,'?',' ', #0,'?',#25, #2,#10,'O','t','h',
    'e','r',' ','I','n','f','o',#25, #2, #9,'?',' ',#24,' ', #0,'?',' ',
    #15,'C','a','l','l','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'C','a',
    'l','l','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'C','a','l','l','s',
    #25,#10, #9,'?',' ', #0,'?',' ',#15,'N','o','d','e',#25,#10, #9,'?',
    ' ',#24,' ', #0,'?',' ',#15,'P','o','s','t','s',#25,#10, #9,'?',' ',
     #0,'?',' ',#15,'P','o','s','t','s',#25,#10, #9,'?',' ', #0,'?',' ',
    #15,'P','o','s','t','s',#25,#10, #9,'?',' ', #0,'?',' ',#15,'U','n',
    'd','e','r',#25, #9, #9,'?',' ',#24,' ', #0,'?',' ',#15,'E','m','a',
    'i','l',#25,#10, #9,'?',' ', #0,'?',' ',#15,'#',' ','U','L',#25,#11,
     #9,'?',' ', #0,'?',' ',#15,'#',' ','U','L',#25,#11, #9,'?',' ', #0,
    '?',' ',#15,'E','r','r','o','r','s',#25, #8, #9,'?',' ',#24,' ', #0,
    '?',' ',#15,'N','e','w','u','s','e','r','s',#25, #7, #9,'?',' ', #0,
    '?',' ',#15,'#',' ','D','L',#25,#11, #9,'?',' ', #0,'?',' ',#15,'#',
    ' ','D','L',#25,#11, #9,'?',' ', #0,'?',' ',#15,'M','a','i','l',#25,
    #10, #9,'?',' ',#24,' ', #0,'?',' ',#15,'F','e','e','d','b','a','c',
    'k',#25, #7, #9,'?',' ', #0,'?',' ',#15,'A','c','t','i','v','i','t',
    'y',#25, #7, #9,'?',' ', #0,'?',' ',#15,'D','a','y','s',#25,#11, #9,
    '?',' ', #0,'?',' ',#15,'U','s','e','r','s',#25, #9, #9,'?',' ',#24,
    ' ', #0,'?',' ',#15,'I','n','c',' ','D','L',#25, #9, #9,'?',' ', #0,
    '?',#25,#16, #9,'?',' ', #0,'?',#25,#16, #9,'?',' ', #0,'?',' ',#15,
    'F','i','l','e','n','o','t','e','s',#25, #5, #9,'?',' ',#24,' ', #0,
    '?',' ',#15,'#',' ','U','L',#25,#11, #9,'?',' ', #0,'?',#25,#16, #9,
    '?',' ', #0,'?',#25,#16, #9,'?',' ', #0,'?',#25,#15, #9,'?',' ',#24,
    ' ', #0,'?',' ',#15,'K','b',' ','U','L',#25,#10, #9,'?',' ', #0,'?',
     #9,#26,#16,'?','?',' ', #0,'?', #9,#26,#16,'?','?',' ', #0,'?', #9,
    #26,#15,'?','?',' ',#24,' ', #0,'?',' ',#15,'#',' ','D','L',#25,#11,
     #9,'?',' ', #0,'?',#26,#23,'?',' ',#15,'M','o','d','e','m',' ', #0,
    #26,#24,'?', #9,'?',' ',#24,' ', #0,'?',' ',#15,'K','b',' ','D','L',
    #25,#10, #9,'?',' ', #0,'?',#16,#25,'7', #9,#17,'?',' ',#24,' ', #0,
    '?',' ',#15,'M','i','n','u','t','e','s',#25, #8, #9,'?',' ', #0,'?',
    #16,#25,'7', #9,#17,'?',' ',#24,' ', #0,'?',' ',#15,'O','v','e','r',
    'l','a','y','s',#25, #7, #9,'?',' ', #0,'?',#16,#25,'7', #9,#17,'?',
    ' ',#24,' ', #0,'?',' ',#15,'M','e','g','s',' ','F','r','e','e',#25,
     #6, #9,'?',' ', #0,'?',#16,#25,'7', #9,#17,'?',' ',#24,' ', #0,'?',
     #9,#26,#16,'?','?',' ', #0,'?', #9,#26,'7','?','?',' ',#24,' ', #0,
    '?',#26,'K','?', #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'S',#15,
    ']','y','s','t','e','m',' ','C','o','n','f','i','g',' ','[',#14,'F',
    #15,']','i','l','e',' ','B','a','s','e',#25, #3,'[',#14,'C',#15,']',
    'a','l','l','e','r','s',#25, #3,'[',#14,'I',#15,']','n','i','t',' ',
    'M','o','d','e','m',#25, #3,'[',#14,'!',#15,']','V','a','l','i','d',
    'a','t','e',#25, #3, #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'U',
    #15,']','s','e','r',' ','E','d','i','t','o','r',#25, #2,'[',#14,'B',
    #15,']','M','s','g',' ','B','a','s','e',#25, #3,'[',#14,'P',#15,']',
    'a','c','k',' ','M','s','g','s',' ',' ','[',#14,'O',#15,']','f','f',
    'h','o','o','k',' ','M','o','d','e','m',' ','[',#14,'L',#15,']','o',
    'g','s',#25, #8, #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'#',#15,
    ']','M','e','n','u',' ','E','d','i','t','o','r',' ',' ','[',#14,'X',
    #15,']','f','e','r',' ','P','r','o','t','s',#25, #2,'[',#14,'M',#15,
    ']','a','i','l',' ','R','e','a','d',' ',' ','[',#14,'A',#15,']','n',
    's','w','e','r',' ','M','o','d','e','m',' ',' ','[',#14,'Z',#15,']',
    'H','i','s','t','o','r','y',#25, #4, #9,'?',' ',#24,' ', #0,'?',' ',
    #15,'[',#14,'E',#15,']','v','e','n','t',' ','E','d','i','t','o','r',
    ' ',' ','[',#14,'W',#15,']','r','i','t','e',' ','M','a','i','l',#25,
     #2,'[',#14,'R',#15,']','e','a','d',' ','M','a','i','l',' ',' ','[',
    #14,'H',#15,']','a','n','g','u','p',' ','M','o','d','e','m',' ',' ',
    '[',#14,'D',#15,']','r','o','p',' ','t','o',' ','D','O','S',' ',' ',
     #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'V',#15,']','o','t','i',
    'n','g',' ','E','d','i','t','o','r',' ','[',#14,'$',#15,']','C','o',
    'n','f','e','r','e','n','c','e','s',' ','[',' ',']',' ','L','o','g',
    ' ','O','n',#25, #2,'[',#14,'N',#15,']','o','d','e',' ','l','i','s',
    't','i','n','g',' ',' ','[',#14,'Q',#15,']','u','i','t',' ','t','o',
    ' ','D','o','s',' ',' ', #9,'?',' ',#24,' ', #0,'?', #9,#26,'K','?',
    '?',' ',#24,#24);}

  WFC0_LENGTH=488;
  WFC0 : array [1..488] of Char = (
    #14,#16,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#24,#17,' ', #0,'?',#26,'K','?', #9,'?',' ',#24,' ', #0,'?',' ',
    #15,'[',#14,'S',#15,']','y','s','t','e','m',' ','C','o','n','f','i',
    'g',' ','[',#14,'F',#15,']','i','l','e',' ','B','a','s','e',#25, #3,
    '[',#14,'C',#15,']','a','l','l','e','r','s',#25, #3,'[',#14,'I',#15,
    ']','n','i','t',' ','M','o','d','e','m',#25, #3,'[',#14,'!',#15,']',
    'V','a','l','i','d','a','t','e',#25, #3, #9,'?',' ',#24,' ', #0,'?',
    ' ',#15,'[',#14,'J',#15,']','u','m','p',' ','t','o',' ','D','O','S',
    #25, #2,'[',#14,'B',#15,']','M','s','g',' ','B','a','s','e',#25, #3,
    '[',#14,'P',#15,']','a','c','k',' ','M','s','g','s',' ',' ','[',#14,
    'O',#15,']','f','f','h','o','o','k',' ','M','o','d','e','m',' ','[',
    #14,'L',#15,']','o','g','s',#25, #8, #9,'?',' ',#24,' ', #0,'?',' ',
    #15,'[',#14,'#',#15,']','M','e','n','u',' ','E','d','i','t','o','r',
    ' ',' ','[',#14,'X',#15,']','f','e','r',' ','P','r','o','t','s',#25,
     #2,'[',#14,'M',#15,']','a','i','l',' ','R','e','a','d',' ',' ','[',
    #14,'A',#15,']','n','s','w','e','r',' ','M','o','d','e','m',' ',' ',
    '[',#14,'Z',#15,']','H','i','s','t','o','r','y',#25, #4, #9,'?',' ',
    #24,' ', #0,'?',' ',#15,'[',#14,'E',#15,']','v','e','n','t',' ','E',
    'd','i','t','o','r',' ',' ','[',#14,'W',#15,']','r','i','t','e',' ',
    'M','a','i','l',#25, #2,'[',#14,'R',#15,']','e','a','d',' ','M','a',
    'i','l',' ',' ','[',#14,'H',#15,']','a','n','g','u','p',' ','M','o',
    'd','e','m',' ',' ','[',#14,'U',#15,']','s','e','r',' ','E','d','i',
    't','o','r',' ',' ', #9,'?',' ',#24,' ', #0,'?',' ',#15,'[',#14,'V',
    #15,']','o','t','i','n','g',' ','E','d','i','t','o','r',' ','[',#14,
    '$',#15,']','C','o','n','f','e','r','e','n','c','e','s',' ','[',#14,
    'D',#15,']','i','s','p','l','a','y',' ','N','S',' ','[',#14,'N',#15,
    ']','o','d','e',' ','l','i','s','t','i','n','g',' ',' ','[',#14,'Q',
    #15,']','u','i','t',' ','t','o',' ','D','O','S',' ',' ', #9,'?',' ',
    #24,' ', #0,'?', #9,#26,'K','?','?',' ',#24,#24);


  {WFC0_LENGTH=344;
  WFC0 : array [1..344] of Char = (
    #15,#16,#24,#24,#24,#24,#24,#24,#24,' ',' ','?',#26,'G','?','?',#24,
    ' ',' ','?',' ',#11,#26,#6 ,'?','?',' ',' ',#26,#6 ,'?',' ',#26,#3 ,
    '?',' ',' ',#26,#3 ,'?',' ',#26,#6 ,'?',' ',#26,#7 ,'?',' ',#26,#6 ,
    '?',' ',#26,#5 ,'?','?',' ',' ',#26,#6 ,'?',' ',#15,'?',#24,' ',' ',
    '?',' ',' ',#11,'?','?',#25,#2 ,'?','?',#25,#2 ,'?','?',#25,#2 ,'?',
    ' ',' ',#26,#3 ,'?',' ',' ','?','?',#25,#2 ,'?','?',#25,#2 ,'?',' ',
    ' ','?','?','?',#25,#2 ,'?',' ','?','?',#25,#2 ,'?','?',' ',' ','?',
    '?',' ',' ','?','?','?',' ',' ','?','?',#25,#2 ,'?',' ',#15,'?',#24,
    ' ',' ','?',' ',' ',#9 ,#26,#5 ,'?','?',#25,#2 ,#26,#3 ,'?',#25,#3 ,
    '?','?',' ','?','?',' ','?','?',#25,#2 ,#26,#3 ,'?',#25,#3 ,'?','?',
    '?',' ','?','?','?',' ',#26,#6 ,'?',' ',' ','?','?',#25,#2 ,'?','?',
    ' ',' ',#26,#3 ,'?',#25,#2 ,#15,'?',#24,' ',' ','?',' ',' ',#1 ,'?',
    '?',' ',' ','?','?','?',#25,#2 ,'?','?',#25,#2 ,'?',' ',' ','?','?',
    ' ',' ',#26,#3 ,'?',#25,#2 ,'?','?',#25,#2 ,'?',' ',' ','?','?','?',
    ' ','?','?','?',' ','?','?',#25,#2 ,'?','?',' ',' ','?','?',' ',' ',
    '?','?','?',' ',' ','?','?',#25,#2 ,'?',' ',#15,'?',#24,' ',' ','?',
    ' ',#1 ,'?','?','?','?',' ',' ','?','?','?',' ',#26,#6 ,'?',' ','?',
    '?','?',#25,#2 ,#26,#3 ,'?',' ',#26,#6 ,'?',' ',#26,#7 ,'?',' ','?',
    '?',#25,#2 ,'?','?',' ',#26,#5 ,'?','?',' ',' ',#26,#6 ,'?',' ',#15,
    '?',#24,' ',' ','?',#26,'G','?','?',#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#24,#24,#24);}

procedure wfcmdefine;
begin
  utoday:=0; dtoday:=0; uktoday:=0; dktoday:=0; etoday:=0; ptoday:=0;
  ftoday:=0; chatt:=0; shutupchatcall:=FALSE;
  contlist:=FALSE; badfpath:=FALSE; telluserevent:=0; timewarn := FALSE;
  fastlogon:=FALSE; fileboard:=1; board:=1; readuboard:= 0; readboard:= 0;
  inwfcmenu:=TRUE; reading_a_msg:=FALSE; smread:=FALSE;
  outcom:=FALSE; useron:=FALSE; ll:=''; chatr:=''; buf:='';
  hangup:=FALSE; chatcall:=FALSE; hungup:=FALSE; timedout:=FALSE;
  rate := 3840;

  textattr := 7; clrscr;
  usernum:=0;
  if maxusers>1 then begin
    loadurec(thisuser,1);
    TempPause := (pause in thisuser.flags);
    reset(SchemeFile);
    if (Thisuser.ColorScheme > 0) and
       (Thisuser.ColorScheme <= filesize(SchemeFile)) then
      seek(SchemeFile, Thisuser.ColorScheme - 1);
    read(SchemeFile, Scheme);
    close(SchemeFile);
    newcomptables;
    usernum:=1;
  end else
    with thisuser do begin
      linelen:=80; pagelen:=25;
      flags:=[hotkey,pause,novice,ansi,color];
      flags:=flags-[avatar];
      reset(SchemeFile);
      read(SchemeFile, Scheme);
      close(SchemeFile);
    end;
end;


procedure GetConnection;
var
  rl,rl1:longint;
  s:astr;
  Done:boolean;
  c:char;

  procedure GetResultCode(const ResultCode:astr);
  var
    i:integer;
  begin
    i := MAXRESULTCODES;    { NOTE!  Done backwards to avoid CONNECT 1200 /
                                     CONNECT 12000 confusion!! }
    Reliable := (pos(Liner.RELIABLE, ResultCode) > 0);
    with Liner do
      repeat
        if (CONNECT[i] <> '') and (pos(CONNECT[i], ResultCode) > 0) then
          begin
            case i of
               1:ActualSpeed := 300;    2:ActualSpeed := 600;
               3:ActualSpeed := 1200;   4:ActualSpeed := 2400;
               5:ActualSpeed := 4800;   6:ActualSpeed := 7200;
               7:ActualSpeed := 9600;   8:ActualSpeed := 12000;
               9:ActualSpeed := 14400; 10:ActualSpeed := 16800;
              11:ActualSpeed := 19200; 12:ActualSpeed := 21600;
              13:ActualSpeed := 24000; 14:ActualSpeed := 26400;
              15:ActualSpeed := 28800; 16:ActualSpeed := 31200;
              17:ActualSpeed := 33600; 18:ActualSpeed := 38400;
              19:ActualSpeed := 57600; 20:ActualSpeed := 115200;
            end;
            Done := TRUE;
          end
        else
          dec(i);
      until (Done) or (i = 1);
  end;
      
begin
  if (AnswerBaud > 0) then
    begin
      ActualSpeed := AnswerBaud;
      if (LockedPort in Liner.MFlags) then
        Speed := Liner.InitBaud
      else
        Speed := ActualSpeed;
      AnswerBaud := 0;
      incom := TRUE;
      exit;
    end;

  Reliable := FALSE;    { Could've been set in boot - don't move }

  Com_Flush_RX;
  if (Liner.Answer <> '') then
    OutModemString(Liner.Answer);
  if (SysOpOn) then
    if (MonitorType = 7) then
      Update_logo(ANSWER,MScreenAddr[(3*2)+(19*160)-162],ANSWER_LENGTH)
     else
       Update_logo(ANSWER,ScreenAddr[(3*2)+(19*160)-162],ANSWER_LENGTH);
  rl1:=Timer; s:=''; rl:=0;
  repeat
    Done := FALSE;
    if (keypressed) then begin
      c := upcase(readkey);
      if (c = ^[) then
        begin
          dtr(FALSE);
          Done := TRUE;
          OutModemString(Liner.Hangup);
          delay(100);
          dtr(TRUE);
          Com_Flush_RX;
        end;
      case c of
        'A':ActualSpeed := 300;   'B':ActualSpeed := 1200;
        'C':ActualSpeed := 2400;  'D':ActualSpeed := 4800;
        'E':ActualSpeed := 7200;  'F':ActualSpeed := 9600;
        'G':ActualSpeed := 12000; 'H':ActualSpeed := 14400;
        'I':ActualSpeed := 16800; 'J':ActualSpeed := 19200;
        'K':ActualSpeed := 38400; 'L':ActualSpeed := 57600;
      end;
      Done := TRUE;
    end;
    c := cinkey;
    if (rl <> 0) and (abs(rl - Timer) > 2) and (c = #0) then
      c:=^M;
    if (c > #0) then
      begin
        WriteWFC(c);
        if (c <> ^M) then
          begin
            if (length(s) >= 160) then
              delete(s, 1, 120);
            s := s + c;
            rl := Timer;
          end
        else
          begin
            if (pos(Liner.NOCARRIER, s) > 0 ) then
              Done := TRUE;
            if (pos(Liner.CALLERID, s) > 0) then
              CallerIDNumber := copy(s, pos(Liner.CALLERID, s) + length(Liner.CallerID), 40);
            GetResultCode(s);
            rl:=0;
          end;
      end;
    if (c = ^M) then
      s := '';
    if (abs(Timer - rl1) > 45) then
      Done := TRUE;
  until Done;
  Com_Flush_RX;
  if (abs(Timer - rl1) > 45) then c:='X';

  incom := (ActualSpeed <> 0);

  if incom and (LockedPort in Liner.MFlags) then
    Speed := Liner.InitBaud
  else
    Speed := ActualSpeed;
end;

procedure WFCDraw;
var
  q:longint;
  s:string[10];
  i,j:integer;
  hf:file of historyrec;
  TodayHistory:HistoryRec;

begin
  window(1, 1, MaxDisplayCols, MaxDisplayRows);
  LastWFCX := 1;
  LastWFCY := 1;
  cursoron(FALSE);
  clrscr;
  if (AnswerBaud > 0) then
    exit;

  if (not BlankMenuNow) and SysOpOn then begin
    if (SysOpOn) then begin
      if (MonitorType = 7) then
        Update_logo(WFC,MScreenAddr[0],WFC_LENGTH)
      else
        Update_logo(WFC,ScreenAddr[0],WFC_LENGTH);

      if general.networkmode then
        if (MonitorType = 7) then
          Update_logo(WFCNET,MScreenAddr[(3*2)+(19*160)-162],WFCNET_LENGTH)
        else
          Update_logo(WFCNET,ScreenAddr[(3*2)+(19*160)-162],WFCNET_LENGTH);

      loadurec(thisuser, 1);
      textattr := 31;
      gotoxy(4,1); write(mrn(time,8));
      gotoxy(68,1); write(date);

      assign(hf,general.datapath+'history.dat');
      reset(hf);
      if (ioresult = 2) then
        rewrite(hf)
      else
        begin
          seek(hf, filesize(hf) - 1);
          read(hf, Todayhistory);
        end;
      close(hf);

      with Todayhistory do begin

        textattr := 19;

        { Today's Stats   }

        gotoxy(14,04); write(mrn(cstr(callers),5));
        gotoxy(14,05); write(mrn(cstr(posts),5));
        gotoxy(14,06); write(mrn(cstr(email),5));
        gotoxy(14,07); write(mrn(cstr(newusers),5));
        gotoxy(14,08); write(mrn(cstr(feedback),5));
        gotoxy(14,09); write(mrn(cstr(uploads),5));
        gotoxy(14,10); write(mrn(cstr(uk),5));
        gotoxy(14,11); write(mrn(cstr(downloads),5));
        gotoxy(14,12); write(mrn(cstr(dk),5));
        gotoxy(14,13); write(mrn(cstr(active),5));
        gotoxy(14,14);
        case OverlayLocation of
          0:write(' Disk');
          1:write('  EMS');
          2:write('  XMS');
        end;
        gotoxy(14,15);

(*        q := diskfree(0) div 1024;*)
        q := diskkbfree(0);
        if (q < general.minspaceforupload) or (q < general.minspaceforpost) then
          textattr := 156;
        str((q div 1024):4,s);
        write(mrn(s,5));
        textattr := 19;

        { System Averages }

        if (general.daysonline =0) then inc(general.daysonline);
        gotoxy(34,04);
        str(((general.totalcalls+callers) / general.daysonline):2:2,s);
        write(mrn(s,5));

        gotoxy(34,05);
        str(((general.totalposts+posts) / general.daysonline):2:2,s);
        write(mrn(s,5));

        gotoxy(34,06);
        str(((general.totaluloads+uploads) / general.daysonline):2:2,s);
        write(mrn(s,5));

        gotoxy(34,07);
        str(((general.totaldloads+downloads) / general.daysonline):2:2,s);
        write(mrn(s,5));

        gotoxy(34,08);
        str(((general.totalusage+active) / general.daysonline) / 14.0:2:2,s);
        write(mrn(s,4),'%');

        { System Totals   }
        gotoxy(53,04); write(mrn(cstr(general.callernum),6));
        gotoxy(53,05); write(mrn(cstr(general.totalposts+posts),6));
        gotoxy(53,06); write(mrn(cstr(general.totaluloads+uploads),6));
        gotoxy(53,07); write(mrn(cstr(general.totaldloads+downloads),6));
        gotoxy(53,08); write(mrn(cstr(general.daysonline),6));

        { Other Info      }

        gotoxy(73,04); write(mrn(cstr(node),5));
        gotoxy(73,05);
        case Tasker of
          None:write('  DOS');
          DesqView:write('   DV');
          Windows:write('  Win');
          OS2:write(' OS/2');
        end;

        gotoxy(73,06); write(mrn(cstr(errors),5));


        if (thisuser.waiting > 0) then
          textattr := 156;
        gotoxy(73,07); write(mrn(cstr(thisuser.waiting),5));
        textattr := 19;

        gotoxy(73,08); write(mrn(cstr(general.numusers),5));


        if (general.totalusage<1) or (general.daysonline<1) then updategeneral;

        textattr := 7;
      end;
    end else
      if (MonitorType = 7) then
         Update_logo(WFC0,MScreenAddr[0],WFC0_LENGTH)
      else
         Update_logo(WFC0,ScreenAddr[0],WFC0_LENGTH);
  end;
end;

procedure wfcmenus;
const
  RingNumber:byte = 0;
  MultiRinging:boolean = FALSE;
var
  u:userrec;
  WFCMessage,
  s:astr;
  LastRing, LastMinute, rl2, LastInit:longint;
  i:integer;
  c,c2:char;
  InBox,RedrawWFC,PhoneOffHook,
  CheckForConnection:boolean;

  procedure InitModem;
  var
    s:astr;
    rl,rl1:longint;
    c:char;
    done:boolean;
    try:integer;
  begin
    c:=#0;
    done:=FALSE;
    try:=0;
    if ((Liner.Init <> '') and (AnswerBaud = 0) and (not LocalioOnly)) then
      begin
        if SysOpOn and not BlankMenuNow then
          begin
            textattr := 31;
            gotoxy(1,17); clreol;
            gotoxy(31,17); write('Initializing modem ...');
          end;
        rl:=Timer;

        while (keypressed) do
          c := readkey;

        repeat
          Com_Set_Speed(Liner.InitBaud);
          Com_Flush_RX;
          OutModemString(Liner.Init);
          s := '';
          rl1 := Timer;
          repeat
            c := cinkey;
            if (c > #0) then
              begin
                WriteWFC(c);
                if (length(s) >= 160) then
                  delete(s, 1, 120);
                s := s + c;
                if (pos(Liner.OK, s) > 0) then
                  Done := TRUE;
              end;
          until ((abs(Timer - rl1) > 3) or (done)) or (keypressed);
          Com_Flush_RX;
          inc(try);
          if (try > 10) then
            Done := TRUE;
        until ((done) or (keypressed));
        if SysOpOn and not BlankMenuNow then
          begin
            gotoxy(1,17); clreol;
          end;
      end;
    PhoneOffHook:=FALSE;
    WFCMessage:='';
    LastInit:=Timer;
    while (keypressed) do
      c := readkey;
    Com_Flush_RX;
    textattr := 7;
  end;

  function cpw:boolean;
  var i:astr;
  begin
    if (not SysOpOn) then
      begin
        textattr := 25;
        write('Password: ');
        textattr := 17;
        echo:=FALSE;
        input(i, 20);
        echo:=TRUE;
        clrscr;
        cpw:=(i=general.sysoppw);
      end
    else
      cpw := TRUE;
  end;

  procedure takeoffhook(showit:boolean);
  begin
    if (not LocalioOnly) then begin
      doPhoneOffHook(showit);
      PhoneOffHook:=TRUE;
      WFCMessage:='Modem off hook';
    end;
  end;

  procedure beephim;
  var
    rl,rl1:longint;
    ch:char;
  begin
    takeoffhook(false);
    beepend:=FALSE;
    rl:=Timer;
    repeat
      sound(1500); delay(20);
      sound(1000); delay(20);
      sound(800); delay(20);
      nosound;
      rl1:=Timer;
      while (abs(rl1-Timer)<0.9) and (not keypressed) do;
    until (abs(rl-Timer)>30) or (keypressed);
    if keypressed then ch:=readkey;
    InitModem;
  end;

  procedure packallbases;
  begin
    clrscr;
    TempPause := FALSE;
    doshowpackbases;
    sysoplog('Message bases packed');
    WFCDraw;
  end;

  procedure chkevents;
  var i,rcode:byte;
      evf:file of eventrec;
  begin
    if (checkevents(0) <> 0) then
    for i:=1 to numevents do
      begin
        if (checkpreeventtime(i,0)) then
          if (not PhoneOffHook) then
            begin
              takeoffhook(false);
              WFCMessage:='Modem off hook in preparation for event at '+
                          copy(ctim(events[i]^.exectime),4,5)+':00';
            end;

          if (checkeventtime(i,0)) then with events[i]^ do
            begin
              assign(evf,general.datapath+'events.dat');
              InitModem;
              if (busyduring) then takeoffhook(true);
              clrscr; write(copy(ctim(exectime),4,5)+':00 - Event: ');
              writeln('"'+description+'"');
              sl1('');
              sl1('Executing event: '+cstr(i) + ' ' + description+' on '+date+' '+time+' from node '+cstr(node));
              case etype of
                'D':begin
                      cursoron(TRUE);
                      durationorlastday:=daynum(date);
                      reset(evf); seek(evf,i-1); write(evf,events[i]^); close(evf);
                      shelldos(FALSE,execdata,rcode);
                      cursoron(FALSE);
                      sl1('Returned from '+description+' on '+date+' '+time);
                      DoPhoneHangup(TRUE);
                      InitModem;
                      WFCDraw;
                    end;
                'E':begin
                      cursoron(TRUE);
                      DoneDay:=TRUE;
                      ExiterrorLevel:=value(execdata);
                      durationorlastday:=daynum(date);
                      reset(evf); seek(evf,i-1); write(evf,events[i]^); close(evf);
                      cursoron(FALSE);
                    end;
                'S':begin
                      durationorlastday:=daynum(date);
                      reset(evf); seek(evf,i-1); write(evf,events[i]^); close(evf);
                      cursoron(FALSE);
                      sortfilesonly:=TRUE;
                      sort;
                      sortfilesonly:=FALSE;
                      InitModem;
                    end;
                'P':begin
                      durationorlastday:=daynum(date);
                      reset(evf); seek(evf,i-1); write(evf,events[i]^); close(evf);
                      cursoron(FALSE);
                      packallbases;
                      InitModem;
                    end;
              end; { case }
            end; { if checkeventtime }
      end; { for i }
      Lasterror := IOResult;
  end;

begin
  if (not general.localsec) or (general.networkmode) then
    SysOpOn:=TRUE
  else
    SysOpOn:=FALSE;
  LastKeyPress := GetPackDateTime;
  InBox        := FALSE;
  BlankMenuNow := FALSE;
  WantOut      := TRUE;
  RedrawWFC    := TRUE;

  InitPort;

  wfcmdefine;

  WFCDraw;

  dtr(TRUE);
  InitModem;

  if (not general.localsec) or (general.networkmode) then
    SysOpOn:=TRUE;
  if (beepend) then WFCMessage:='Modem off hook - paging SysOp';
  randomize;
  textattr:=curco;
  cursoron(FALSE); LastMinute:=Timer - 61;
  CheckForConnection := FALSE;

  if (AnswerBaud > 0) and not (LocalioOnly) then
    begin
      c:='A';
      incom:=com_carrier;
    end
  else
    begin
      c := #0;
      CallerIDNumber := '';
    end;

  if (WFCMessage<>'') and (SysOpOn) and not (BlankMenuNow) then begin
    gotoxy((80 - length(WFCMessage)) div 2, 17);
    textattr := 31;
    write('?? '); write(WFCMessage); write(' ??');
  end;

  textattr := 3;

  if (beepend) then beephim;

  if (doneafternext) then begin
    takeoffhook(true);
    ExiterrorLevel:=exitnormal;
    hangup:=TRUE;
    DoneDay:=TRUE;
    clrscr;
  end;

  s := '';

  repeat
    incom:=FALSE; outcom:=FALSE; fastlogon:=FALSE; ActualSpeed := 0;
    hangup:=FALSE; hungup:=FALSE; irt:=''; lastauthor:=0; cfo:=FALSE;
    Speed := 0; freetime:=0; extratime:=0; choptime:=0; credittime := 0; lil:=0;

    asm int 28h end;

    if (AnswerBaud = 0) then begin
      if (Timer - LastMinute > 60) or (Timer - LastMinute < 0) then begin
         LastMinute:=Timer;
         if (SysOpOn) and not (BlankMenuNow) then
           begin
             textattr := 31;
             gotoxy(4,1); write(mrn(time,8));
             gotoxy(68,1); write(date);
             textattr := 15;
           end;
         if (Timer - LastInit > NoCallInitTime) then begin
            LastInit := Timer;
            if (not PhoneOffHook) and (AnswerBaud=0) then
              begin
                Com_Deinstall;
                InitPort;
                InitModem;
              end;
            if (general.multinode) then begin
              loadurec(thisuser,1);
              savegeneral(TRUE);
            end;
         end;
         if SysOpOn and general.localsec and not general.networkmode then
           SysOpOn:=FALSE;
         if ((not BlankMenuNow) and (general.wfcblanktime > 0)) then
           if ((GetPackDateTime - LastKeyPress) div 60 >= general.wfcblanktime) then
             begin
               BlankMenuNow:=TRUE;
               clrscr;
             end;
         if (numevents>0) then
           chkevents;
      end;
      c:=char(inkey);
    end;

    if (InBox) and (c > #0) then
      begin
        if (C in [#9, #27]) then
          begin
            InBox := FALSE;
            window(1, 1, MaxDisplayCols, MaxDisplayRows);
            gotoxy(32, 17); clreol;
          end
        else
          begin
            Com_TX(c);
            WriteWFC(c);
          end;
        c := #0;
      end;

    if (c > #0) then begin
      TempPause := (pause in thisuser.flags);
      RedrawWFC := TRUE;
      if (BlankMenuNow) then
        begin
          BlankMenuNow:=FALSE;
          WFCDraw;
          LastKeyPress := GetPackDateTime;
        end;

      c:=upcase(c);
      cursoron(TRUE);
      if (not SysOpOn) then
        case c of
          'Q':begin
                ExiterrorLevel := 255;
                hangup := TRUE;
                DoneDay := TRUE;
              end;
          ' ':begin
                SysOpOn:=cpw;
                if (SysOpOn) then WantOut:=TRUE;
                c:=#1;
              end;
          else
              RedrawWFC := FALSE;
        end
      else begin
        textattr := 7;
        curco := 7;
       { textattr:=thisuser.cols[color in thisuser.flags][1];
        curco:=thisuser.cols[color in thisuser.flags][1]; }
        if General.Networkmode and (Answerbaud = 0) and (pos(c,'HIABCDEFJTV$PLNMOS!RUWXZ#') > 0) then
          c := #0;

        case c of
           #9:begin
                InBox := TRUE;
                textattr := 31;
                gotoxy(32, 17); write('Talking to modem ...');
                RedrawWFC := FALSE;
              end;
          'H':begin
                DoPhoneHangup(TRUE);
                RedrawWFC := FALSE;
              end;
          'I':begin
                InitModem;
                RedrawWFC := FALSE;
              end;
          'A':if not LocalioOnly then
                CheckForConnection := TRUE
              else
                RedrawWFC := FALSE;
          'B':if cpw then boardedit;
          'C':begin
                todayscallers(0, '');
                pausescr(FALSE);
              end;
          'D':begin end;  {****}
          'E':if cpw then eventedit;
          'F':if cpw then dlboardedit;
          'J':SysOpShell;
          'V':if cpw then editvotes;
          '$':if cpw then confeditor;
          'P':begin
                clrscr;
                if (pynq('Pack the message bases? '))
                  then doshowpackbases;
              end;
          'L':begin
                clrscr;
                showlogs;
                nl; pausescr(FALSE);
              end;
          'N':begin
                clrscr;
                list_nodes;
                pausescr(FALSE);
              end;
          'M':if cpw then begin
                 clrscr;
                 mailr;
              end;
          'O':begin
                takeoffhook(true);
                RedrawWFC := FALSE;
              end;
          'S':if cpw then changestuff;
          '!':begin
                clrscr;
                validatefiles;
              end;
          'Q':begin
                 ExiterrorLevel := 255;
                 hangup := TRUE;
                 DoneDay := TRUE;
                 RedrawWFC := FALSE;
              end;
          'R':if cpw then
                begin
                  clrscr;
                  usernum:=-1;
                  write('User''s mail to check: ');
                  finduserws(i);
                  if (i < 1) then
                    pausescr(FALSE)
                  else
                    begin
                      loadurec(thisuser,i);
                      usernum:=i;
                      clrscr;
                      readmail;
                      usernum:=0;
                      saveurec(thisuser,i);
                      loadurec(thisuser,1);
                    end;
                  usernum := 1;
                end;
          'U':if cpw then
                begin
                  clrscr;
                  uedit(usernum);
                end;
          'W':if cpw then
                begin
                  clrscr;
                  write('User to send mail from: ');
                  finduserws(i);
                  writeln;
                  if (i < 1) then
                    pausescr(FALSE)
                  else
                    begin
                      loadurec(thisuser,i);
                      usernum:=i;
                      smail(pynq('Send mass mail? '));
                      nl; pausescr(FALSE);
                      loadurec(thisuser,1);
                      usernum:=1;
                    end;
                end;
          'X':if cpw then exproedit;
          'Z':begin
                clrscr;
                history;
                pausescr(FALSE);
              end;
          '#':if cpw then
                menu_edit;
          ' ':begin
                if (general.offhooklocallogon) then
                  takeoffhook(true);
                gotoxy(32,17);
                textattr := 31;
                write('Log on? (Y/N');
                if not general.localsec then
                  write('/Fast) : ')
                else
                  write(') : ');
                rl2:=Timer;
                while (not keypressed) and (abs(Timer - rl2) < 10) do;
                if (keypressed) then
                  c := upcase(readkey)
                else
                  c := 'N';
                writeln(c);
                case c of
                  'F':if not general.localsec then
                        begin
                          fastlogon:=TRUE;
                          c:=' ';
                        end;
                  'Y':c:=' ';
                else
                  begin
                    if SysOpOn and not BlankMenuNow then
                      begin
                        gotoxy(1,17); clreol;
                      end;
                    if (general.offhooklocallogon) then
                      InitModem;
                    RedrawWFC := FALSE;
                  end;
                end;
              end;
          else
              RedrawWFC := FALSE;
        end;
        LastKeyPress := GetPackDateTime;
      end;
      if (RedrawWFC) then
        begin
          if not (c in ['A','I','H',' ']) then
            begin
              curco:=7; textattr:=curco;
              WFCDraw;
              InitModem;
            end;
        end;
    end;


    if (not Com_RX_Empty) then
      begin
        c2 := cinkey;
        if (c2 > #0) then
          begin
            WriteWFC(c2);
            if (length(s) >= 160) then
              delete(s, 1, 120);
            if (c2 <> ^M) then
              s := s + c2
            else
              begin
                if (pos(Liner.CALLERID, s) > 0) then
                  begin
                    CallerIDNumber := copy(s, pos(Liner.CALLERID, s) + length(Liner.CallerID), 40);
                    s := '';
                  end;
                  if (pos(Liner.RING, s) > 0) then
                    begin
                      s := '';
                      if (RingNumber > 0) and (abs(Timer - LastRing) > 10) then
                        begin
                          RingNumber := 0;
                          CallerIDNumber := '';
                          MultiRinging := FALSE;
                        end;

                      if (abs(Timer - LastRing) < 4) and (not MultiRinging) then
                        MultiRinging := TRUE
                      else
                        inc(RingNumber);

                      LastRing := Timer;
                      if (RingNumber >= Liner.AnswerOnRing) and
                         (Not Liner.MultiRing or MultiRinging) then
                        CheckForConnection := TRUE;
                      s := '';
                    end;
              end;
          end;
      end;
    if (c > #0) or (CheckForConnection) then
      begin
        if (not general.localsec) or (general.networkmode) then
          SysOpOn := TRUE;
        if BlankMenuNow then
          begin
            BlankMenuNow := FALSE;
            WFCDraw;
          end;
        if (not PhoneOffHook) and (not LocalioOnly) and CheckForConnection then
          begin
            GetConnection;
            CheckForConnection := FALSE;
            if (not incom) then
              begin
                WFCDraw;
                InitModem;
                if (quitafterdone) then
                  begin
                    ExiterrorLevel := exitnormal;
                    hangup := TRUE;
                    DoneDay := TRUE;
                  end;
              end;
          end;
      end;
      cursoron(FALSE);
  until ((incom) or (c=' ') or (DoneDay));

  etoday:=0; ptoday:=0; ftoday:=0; chatt:=0; shutupchatcall:=FALSE;
  ChatChannel := 0;
  contlist:=FALSE; badfpath:=FALSE; usernum:=-1;  TempSysop := FALSE;

  reset(SchemeFile);
  read(SchemeFile, Scheme);
  close(SchemeFile);

  curco:=7; textattr:=curco;
  if (incom) then
    begin
      Com_Flush_RX;
      dtr(TRUE);
      outcom := TRUE;
      Com_Set_Speed(Speed);
    end
  else
    begin
      dtr(FALSE);
      outcom := FALSE;
    end;
  if (ActualSpeed = 0) then
    rate := Liner.InitBaud div 10
  else
    rate := ActualSpeed div 10;
  timeon := GetPackDateTime;
  clrscr;
  Com_Flush_RX;
  beepend:=FALSE;
  inwfcmenu:=FALSE;

  kill(general.multpath + 'message.'+cstr(node));
  nodechatlastrec:=0;

  if (Speed = 0) and (not WantOut) then
    WantOut:=TRUE;
  if (WantOut) then
    cursoron(TRUE);

  savegeneral(TRUE);  { Get the latest updated RENEGADE.DAT }

  Lasterror := IOResult;
end;
end.
