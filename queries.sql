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
DECLARE VARIABLE lOwner CHAR(12);
BEGIN
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

select "fName" from "tModel" where "fGroup" = '0602000000Fj'; покажет товары для группы
select "fName" from "tGroup" where "fObject" = '0602000000Fj'; покажет имя группы

select "fName" from "tModel" where "fGroup" = '0602000000Ff';
select "fName" from "tModel" where "fGroup" in (select "fObject" from "tGroup" where "fName" = 'Сколково');
select "fCount" from "tGoods" where "fModel" in (select "fObject" from "tModel" where "fGroup" in (select "fObject" from "tGroup" where "fName" = 'Склад'));