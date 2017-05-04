pGoodsCGet
DECLARE VARIABLE lOwner CHAR(12);
BEGIN
  "oRoot" = 1;
  SELECT "fLazy" FROM "tObject" WHERE "UID" = :aObject INTO :"oLazy";
  IF ("oLazy" = 0) THEN
  BEGIN
    "oRoot" = 0;
    SELECT "fDoc" FROM "tGoodsC" WHERE "fObject" = :aObject INTO lOwner;
    SELECT "oLazy" FROM "pGetLazy"(:lOwner) INTO :"oLazy";
  END
  SUSPEND;
END

pGroupGetL
BEGIN
  "oRoot" = 1;
  SELECT "fLazy" FROM "tObject" WHERE "UID" = :aObject INTO :"oLazy";
  SUSPEND;
END

pGoodsGetL
DECLARE VARIABLE lOwner CHAR(12);BEGIN
  "oRoot" = 1;
  SELECT "fLazy" FROM "tObject" WHERE "UID" = :aObject INTO :"oLazy";
  IF ("oLazy" = 0) THEN
  BEGIN
    "oRoot" = 0;
    SELECT "fDoc" FROM "tGoods" WHERE "fObject" = :aObject INTO lOwner;
    SELECT "oLazy" FROM "pGetLazy"(:lOwner) INTO :"oLazy";
  END
  SUSPEND;
END

"tDoc" ("fObject",      "fType",           "fFirm",        "fFirmCargo",   "fPartner",     "fPartnerCargo", "fDate", 	  "fName", "fNum",  "fCurr",        "fByCurr", "fSumMethod", "fPrecision",    "fSum",    "fMark", "fState", "fDateAcc")
       ('0607000000Ff', 'doc-procuration', '0606000000G4', '000000000000', '0606000000Fh', '000000000000',  '2017-03-08',  '1',      1,     '000000000000',   '0  ',      'AA',           2,          34710.32,    '1  ',    '',    '1899-12-30');


"tGoods" ("fObject",      "fDoc",           "fCount", "fPrice", "fNDS", "fNDSMode", "fModel",       "fQName", "fOrderA", "fVolume",     "fGTD", "fCountry",     "fPack",        "fCoefficient", "fPriceDC", "fForceSumN")
         ('060800000001', '0607000000Ff ',      5,      3920,     18,       1,      '0605000000Fd',     '',       0,     '0601000000Fd',  '',   '000000000000', '000000000000',     0,              0,          0       );


"tModel" ("fObject",      "fName",                  "fPrice", "fNDS", "fNDSMode",   "fGroup",       "fVolume",      "fCurr",        "fGTD", "fCountry",     "fNote1", "fNote2",     "fPack",        "fCoefficient", "fIdCode")
         ('0605000000Fd', 'Устройство УЗНКЛ-II-0',      3920,   18,         1,      '0602000000Ff', '0601000000Fd', '000000000000', '',     '000000000000',    '',       '',       '000000000000',     0,              ''   );

"tGroup" ("fObject",        "fParent",      "fName",    "fPrint") 
         ('0602000000Ff',   '000000000000', 'Баковка',  '   '   );

"tVolume" ("fObject",       "fName", "fOKEI")
          ('0601000000Fd',  'шт.',    ''    );


select "fName" from "tModel" where "fGroup" = '0602000000Fj'; покажет товары для группы
select "fName" from "tGroup" where "fObject" = '0602000000Fj'; покажет имя группы

select "fName" from "tModel" where "fGroup" = '0602000000Ff';
select "fName" from "tModel" where "fGroup" in (select "fObject" from "tGroup" where "fName" = 'Сколково');
select "fCount" from "tGoods" where "fModel" in (select "fObject" from "tModel" where "fGroup" in (select "fObject" from "tGroup" where "fName" = 'Склад'));

select count("fObject") from "tGoods" where "fModel" = '0605000000JS';

select "fCount" from "tGoods" where "fModel" = '0605000000JS'; количество
select "fCount" from "tGoods" where "fModel" = '0605000000Js';

select "fNum" from "tDoc" order by "fDate"; номера заказов в порядке по дате
select "fNum", "fDate" from "tDoc" order by "fDate"; с выводом даты