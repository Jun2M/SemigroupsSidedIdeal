#############################################################################
##
#W  r.tst
#Y  Copyright (C) 2006-2010                             James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
## $Id$
##

#ReadTest( Filename( DirectoriesPackageLibrary( "monoid", "tst" ), "r.tst"));
# takes approx. 15s

gap> START_TEST("r.tst 4.0");
#gap> SetGasmanMessageStatus("none");
gap> LoadPackage("semex");;
gap> gens:=[ 
>  Transformation( [ 1, 54, 25, 4, 49, 30, 7, 56, 51, 44, 31, 62, 13, 20, 35, 
>      38, 61, 18, 37, 14, 63, 42, 23, 24, 3, 58, 27, 34, 55, 6, 11, 32, 45, 28, 
>      15, 36, 19, 16, 59, 64, 41, 22, 53, 10, 33, 46, 47, 50, 5, 48, 9, 52, 43, 
>      2, 29, 8, 57, 26, 39, 60, 17, 12, 21, 40 ] ), 
>  Transformation( [ 1, 56, 21, 36, 61, 26, 7, 48, 3, 28, 55, 14, 41, 54, 33, 
>      62, 43, 4, 11, 2, 51, 40, 13, 46, 63, 22, 47, 6, 19, 58, 29, 18, 39, 30, 
>      45, 52, 31, 12, 35, 10, 23, 64, 5, 34, 59, 24, 57, 38, 17, 16, 25, 60, 
>      49, 8, 37, 50, 27, 42, 15, 32, 53, 20, 9, 44 ] ), 
>  Transformation( [ 1, 64, 33, 18, 11, 8, 7, 10, 15, 14, 17, 26, 23, 22, 25, 
>      30, 29, 32, 49, 42, 39, 38, 41, 46, 45, 48, 57, 54, 53, 56, 61, 60, 63, 
>      2, 3, 4, 5, 6, 9, 12, 13, 16, 19, 20, 21, 24, 27, 28, 31, 34, 35, 36, 37, 
>      40, 43, 44, 47, 50, 51, 52, 55, 58, 59, 62 ] ), 
>  Transformation( [ 1, 3, 19, 27, 31, 33, 1, 63, 29, 59, 61, 21, 23, 51, 53, 
>      25, 55, 57, 5, 9, 11, 35, 41, 7, 37, 39, 13, 15, 43, 45, 17, 47, 49, 35, 
>      43, 47, 49, 3, 17, 45, 13, 15, 37, 39, 5, 7, 41, 9, 11, 51, 55, 57, 19, 
>      25, 53, 21, 23, 59, 61, 27, 29, 63, 31, 33 ] ), 
>  Transformation( [ 1, 18, 57, 46, 41, 36, 7, 4, 47, 18, 13, 60, 1, 32, 27, 52, 
>      23, 24, 23, 32, 27, 60, 1, 24, 57, 52, 7, 4, 41, 36, 13, 46, 47, 4, 27, 
>      24, 23, 52, 57, 32, 1, 60, 13, 18, 47, 46, 7, 36, 41, 36, 47, 46, 13, 18, 
>      41, 4, 7, 52, 57, 24, 23, 60, 27, 32 ] ) ];;
gap> s:=Semigroup(gens);;
gap> DegreeOfTransformationSemigroup(s);
64
gap> f:=Transformation( 
> [ 53, 15, 42, 7, 6, 36, 20, 59, 6, 29, 37, 48, 52, 4, 32, 18, 
> 13, 55, 49, 42, 46, 35, 52, 7, 53, 27, 9, 33, 41, 18, 63, 29, 42, 33, 56, 63,
> 64, 49, 35, 3, 20, 2, 26, 11, 39, 9, 7, 48, 8, 56, 42, 10, 61, 25, 55, 39, 62,
> 21, 34, 57, 44, 14, 14, 53 ] );;
gap> f in s;
false
gap> GreensRClassOfElement(s, f);
#I  transformation is not an element of the semigroup
fail
gap> f:=Transformation( [ 1, 33, 49, 57, 61, 63, 1, 59, 53, 51, 55, 39, 41, 35,
> 37, 45, 43, 47, 11, 15, 17, 3, 13, 7, 5, 9, 23, 25, 19, 21, 29, 27, 31, 3, 19,
> 27, 31, 33, 29, 21, 23, 25, 5, 9, 11, 7, 13, 15, 17, 35, 43, 47, 49, 45, 37, 
> 39, 41, 51, 55, 57, 53, 59, 61, 63 ] );;
gap> f in s;
true
gap> r1:=GreensRClassOfElement(s, f);;
gap> s:=OrderPreservingSemigroup(12);
<semigp of order-preserving maps on 12 pts>
gap> f:=Transformation([1,1,2,4,5,5,5,5,6,12,12,12]);;
gap> r:=GreensRClassOfElementNC(s, f);;
#gap> time;
#193
gap> r2:=GreensRClassOfElement(s, f);;
#gap> time;
#735
gap> r=r2;
true
gap> Representative(r) in r2;
true
gap> Representative(r2) in r;
true
gap> gens:=[ Transformation( [ 5, 1, 4, 6, 2, 3 ] ), 
> Transformation( [ 1, 2, 3, 4, 5, 6 ] ), 
> Transformation( [ 4, 6, 3, 4, 2, 5 ] ), 
> Transformation( [ 5, 4, 6, 3, 1, 3 ] ), 
> Transformation( [ 2, 2, 6, 5, 4, 3 ] ), 
> Transformation( [ 3, 5, 5, 1, 2, 4 ] ), 
> Transformation( [ 6, 5, 1, 3, 3, 4 ] ), 
> Transformation( [ 1, 3, 4, 3, 2, 1 ] ) ];;
gap> s:=Semigroup(gens);;
gap> ExpandOrbitsOfImages(s);
true
#gap> time;
#36
gap> Size(s);
43779
gap> NrGreensRClasses(s);
200
gap> iter:=IteratorOfGreensRClasses(s);
<iterator of R-classes>
gap> r:=NextIterator(iter);
{Transformation( [ 1, 2, 3, 4, 5, 6 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 4, 6, 3, 4, 2, 5 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 2, 6, 3, 4, 5, 4 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 2, 2, 6, 5, 4, 3 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 5, 4, 4, 6, 2, 3 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 3, 2, 5, 4, 4, 6 ] )}
gap> r:=NextIterator(iter);
{Transformation( [ 1, 3, 4, 3, 2, 1 ] )}
gap> d:=GreensDClass(r);
{Transformation( [ 1, 3, 4, 3, 2, 1 ] )}
#gap> time;
#19
gap> Size(d);
23400
gap> Position(GreensDClasses(s), d);
1
gap> List(GreensRClasses(s), x-> Position(GreensDClasses(s), GreensDClass(x)));
[ 2, 3, 3, 3, 3, 3, 1, 1, 1, 1, 4, 3, 1, 1, 1, 3, 1, 4, 3, 1, 1, 1, 4, 3, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 4, 4, 1, 1, 4, 1, 4, 4, 4, 4, 4, 4, 4,
  4, 4, 4, 5, 3, 1, 1, 1, 1, 1, 4, 4, 5, 1, 1, 4, 1, 1, 4, 4, 3, 1, 1, 4, 4,
  4, 4, 4, 4, 1, 1, 4, 4, 4, 1, 1, 1, 4, 4, 4, 4, 4, 3, 1, 1, 4, 1, 4, 4, 1,
  1, 4, 4, 1, 4, 1, 4, 4, 4, 4, 1, 4, 4, 4, 4, 1, 4, 4, 4, 4, 1, 4, 4, 4, 5,
  1, 4, 4, 4, 4, 4, 4, 1, 4, 4, 5, 4, 4, 4, 4, 5, 5, 5, 5, 4, 5, 5, 5, 4, 5,
  5, 5, 4, 1, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 1, 4, 1, 1, 4, 5, 5, 5, 1,
  4, 1, 5, 5, 1, 1, 4, 5, 1, 1, 4, 5, 1, 4, 4, 5, 4, 4, 5, 5, 5, 6, 4, 4, 4 ]
gap> gens:=[ Transformation( [ 1, 2, 6, 4, 7, 5, 7 ] ),
>  Transformation( [ 2, 1, 6, 4, 5, 6, 7 ] ),
>  Transformation( [ 1, 7, 4, 6, 3, 2, 6 ] ),
>  Transformation( [ 5, 2, 4, 5, 6, 6, 3 ] ),
>  Transformation( [ 1, 4, 5, 6, 7, 3, 7 ] ),
>  Transformation( [ 1, 5, 2, 7, 3, 6, 6 ] ),
>  Transformation( [ 7, 3, 5, 6, 2, 1, 2 ] ),
>  Transformation( [ 3, 6, 2, 6, 7, 4, 1 ] ),
>  Transformation( [ 2, 5, 3, 3, 1, 6, 7 ] ),
>  Transformation( [ 3, 7, 6, 7, 4, 2, 5 ] ),
>  Transformation( [ 2, 6, 2, 5, 4, 7, 3 ] ),
>  Transformation( [ 2, 7, 6, 4, 5, 4, 3 ] ),
>  Transformation( [ 3, 3, 2, 7, 5, 1, 3 ] ),
>  Transformation( [ 7, 1, 1, 3, 1, 6, 2 ] ),
>  Transformation( [ 5, 6, 3, 2, 1, 4, 6 ] ),
>  Transformation( [ 2, 3, 1, 7, 2, 3, 4 ] ),
>  Transformation( [ 5, 2, 2, 5, 7, 6, 1 ] ),
>  Transformation( [ 2, 5, 7, 4, 5, 3, 1 ] ),
>  Transformation( [ 5, 2, 4, 5, 7, 3, 4 ] ),
>  Transformation( [ 7, 5, 1, 2, 2, 5, 3 ] ),
>  Transformation( [ 7, 3, 3, 5, 1, 7, 4 ] ),
>  Transformation( [ 1, 6, 6, 3, 3, 7, 1 ] ) ];;
gap> s:=Semigroup(gens);
<semigroup with 22 generators>
gap> f:=Transformation( [ 1, 5, 3, 2, 7, 6, 7 ] );;
gap> f in s;
true
gap> d:=GreensDClassOfElement(s, f);
{Transformation( [ 5, 2, 4, 1, 7, 6, 7 ] )}
#gap> time;
#19
gap> reps:=GreensRClassReps(d);
[ Transformation( [ 1, 2, 6, 4, 7, 5, 7 ] ) ]
#gap> time;
#33
gap> List(reps, x-> Position(GreensRClasses(s), GreensRClassOfElement(s, x)));;
gap> Size(s);
677391
gap> r:=GreensRClasses(s)[63];;
gap> Idempotents(r);
[ Transformation( [ 1, 2, 5, 2, 5, 5, 7 ] ),
  Transformation( [ 1, 2, 6, 2, 6, 6, 7 ] ),
  Transformation( [ 1, 2, 3, 2, 3, 3, 7 ] ),
  Transformation( [ 1, 4, 3, 4, 3, 3, 7 ] ),
  Transformation( [ 1, 4, 6, 4, 6, 6, 7 ] ),
  Transformation( [ 1, 4, 5, 4, 5, 5, 7 ] ) ]
gap> last[2] in r;
true
gap> gens:=[ Transformation( [ 2, 8, 3, 7, 1, 5, 2, 6 ] ), 
>  Transformation( [ 3, 5, 7, 2, 5, 6, 3, 8 ] ), 
>  Transformation( [ 4, 1, 8, 3, 5, 7, 3, 5 ] ), 
>  Transformation( [ 4, 3, 4, 5, 6, 4, 1, 2 ] ), 
>  Transformation( [ 5, 4, 8, 8, 5, 6, 1, 5 ] ), 
>  Transformation( [ 6, 7, 4, 1, 4, 1, 6, 2 ] ), 
>  Transformation( [ 7, 1, 2, 2, 2, 7, 4, 5 ] ), 
>  Transformation( [ 8, 8, 5, 1, 7, 5, 2, 8 ] ) ];;
gap> s:=Semigroup(gens{[1..4]});;
gap> ExpandOrbitsOfImages(s);;
gap> t:=ClosureSemigroupNC(s, gens{[5..8]});;
gap> Size(t);
597369
gap> gens[5] in s;
false
gap> gens:=[ Transformation( [ 3, 4, 1, 2, 1 ] ), 
> Transformation( [ 4, 2, 1, 5, 5 ] ), 
> Transformation( [ 4, 2, 2, 2, 4 ] ) ];;
gap> s:=Semigroup(gens{[1,2]});;
gap> t:=ClosureSemigroup(s, [gens[3]]);;
gap> ExpandOrbitsOfImages(t);;
gap> gens[3] in s;
false
gap> gens:=[ Transformation( [ 6, 7, 1, 2, 3, 4, 5 ] ), 
>  Transformation( [ 7, 6, 5, 4, 3, 2, 1 ] ), 
>  Transformation( [ 4, 5, 6, 7, 1, 2, 3 ] ), 
>  Transformation( [ 5, 6, 6, 5, 4, 3, 4 ] ), 
>  Transformation( [ 5, 4, 3, 2, 3, 3, 4 ] ), 
>  Transformation( [ 5, 4, 3, 3, 4, 4, 4 ] ), 
>  Transformation( [ 1, 7, 1, 1, 1, 1, 2 ] ), 
>  Transformation( [ 5, 6, 6, 5, 4, 4, 5 ] ) ];;
gap> s:=Semigroup(gens);;
gap> f:=Transformation( [ 7, 6, 5, 4, 3, 2, 1 ] );;
gap> f in s;
true
gap> r:=RClass(s, f);
{Transformation( [ 1, 2, 3, 4, 5, 6, 7 ] )}
gap> l:=LClass(s, f);
{Transformation( [ 7, 6, 5, 4, 3, 2, 1 ] )}
gap> h:=HClass(s,f);
{Transformation( [ 1, 2, 3, 4, 5, 6, 7 ] )}
gap> d:=DClass(s,f);
{Transformation( [ 7, 6, 5, 4, 3, 2, 1 ] )}
gap> r=l; r=h; l=r; h=r; d=r; r=d; r=r;
true
true
true
true
true
true
true
gap> f:=Transformation( [ 5, 4, 3, 3, 4, 4, 4 ] );;
gap> rr:=RClass(s, f);; ll:=LClass(s, f);;
gap> hh:=HClass(s, f);; dd:=DClass(s, f);;
gap> r=rr; r=ll; r=hh; r=dd; rr=ll; rr=hh; rr=dd;
false
false
false
false
false
false
false
gap> gens:=[ Transformation( [ 5, 1, 4, 6, 2, 3 ] ), 
> Transformation( [ 1, 2, 3, 4, 5, 6 ] ), 
> Transformation( [ 4, 6, 3, 4, 2, 5 ] ), 
> Transformation( [ 5, 4, 6, 3, 1, 3 ] ), 
> Transformation( [ 2, 2, 6, 5, 4, 3 ] ), 
> Transformation( [ 3, 5, 5, 1, 2, 4 ] ), 
> Transformation( [ 6, 5, 1, 3, 3, 4 ] ), 
> Transformation( [ 1, 3, 4, 3, 2, 1 ] ) ];;
gap> s:=Semigroup(gens);;
gap> f:=Transformation( [ 6, 1, 1, 2, 5, 3 ] );;
gap> r:=RClass(s, f);
{Transformation( [ 5, 4, 4, 6, 2, 3 ] )}
gap> List(gens, x-> x in r);
[ false, false, false, false, false, true, false, false ]
gap> rr:=RClass(s, gens[6]);
{Transformation( [ 5, 4, 4, 6, 2, 3 ] )}
gap> gens[6] in rr; r=rr; f in rr; f in r;
true
true
true
true
gap> Size(r); Number(s, x-> x in r);
720
720
gap> gens:=[ Transformation( [ 5, 6, 7, 3, 1, 4, 2, 8 ] ), 
>   Transformation( [ 3, 6, 8, 5, 7, 4, 2, 8 ] ) ];;
gap> s:=Semigroup(gens);;
gap> f:=Transformation( [ 5, 2, 7, 4, 8, 6, 8, 8 ] );;
gap> r:=RClass(s, f);;
gap> Size(r);
1200
gap> ForAll(r, x-> x in r);
true
#gap> time;
#24
gap> g:=Transformation( [ 6, 8, 2, 5, 8, 4, 8, 8 ] );;
gap> rr:=RClass(s, g);;
gap> ForAny(rr, x-> x in r);
false
gap> ForAny(r, x-> x in rr);
false
gap> gens:=[Transformation([2,3,4,5,1,8,7,6,2,7]), 
> Transformation( [ 3, 8, 7, 4, 1, 4, 3, 3, 7, 2 ] )];;
gap> s:=Monoid(gens);;
gap> f:=Transformation( [ 3, 7, 7, 4, 3, 4, 3, 3, 3, 3 ] );;
gap> r:=RClass(s, f);;
gap> ForAll(r, x-> x in r);
true
gap> gens:=[ Transformation( [ 1, 3, 2, 3 ] ), 
>  Transformation( [ 1, 4, 1, 2 ] ),
>  Transformation( [ 3, 4, 2, 2 ] ), 
>  Transformation( [ 4, 1, 2, 1 ] ) ];;
gap> s:=Monoid(gens);;
gap> f:=Transformation( [ 3, 1, 1, 1 ] );;
gap> r:=RClass(s, f);;
gap> Set(Filtered(s, x-> x in r))=Elements(r);
true
gap> gens:=[ Transformation( [ 2, 8, 3, 7, 1, 5, 2, 6 ] ), 
>   Transformation( [ 3, 5, 7, 2, 5, 6, 3, 8 ] ), 
>   Transformation( [ 4, 1, 8, 3, 5, 7, 3, 5 ] ), 
>   Transformation( [ 4, 3, 4, 5, 6, 4, 1, 2 ] ), 
>   Transformation( [ 5, 4, 8, 8, 5, 6, 1, 5 ] ), 
>   Transformation( [ 6, 7, 4, 1, 4, 1, 6, 2 ] ), 
>   Transformation( [ 7, 1, 2, 2, 2, 7, 4, 5 ] ), 
>   Transformation( [ 8, 8, 5, 1, 7, 5, 2, 8 ] ) ];;
gap> s:=Semigroup(gens);;
gap> DisplayOrbitsOfImages(s);
finished: 	false
orbits: 	
at: 		0
ht: 		<tree hash table len=100003 used=9 colls=0 accs=9>
size: 		0
R-classes: 	0
data ht: 	<tree hash table len=100003 used=0 colls=0 accs=0>
images: 	<tree hash table len=100003 used=0 colls=0 accs=0>
true
gap> iter:=IteratorOfGreensRClasses(s);
<iterator of R-classes>
gap> repeat r:=NextIterator(iter); until Size(r)>1;
gap> repeat r:=NextIterator(iter); until Size(r)>1;
gap> repeat r:=NextIterator(iter); until Size(r)>1;
gap> r;                                             
{Transformation( [ 4, 8, 1, 5, 1, 5, 4, 6 ] )}
gap> Size(r);
2640
gap> enum:=Enumerator(r);
<enumerator of R-class>
gap> enum[1];
Transformation( [ 4, 8, 1, 5, 1, 5, 4, 6 ] )
gap> enum[2];
Transformation( [ 4, 6, 1, 5, 1, 5, 4, 8 ] )
gap> enum[43];
Transformation( [ 8, 6, 4, 1, 4, 1, 8, 5 ] )
gap> enum[1368];
Transformation( [ 5, 8, 7, 4, 7, 4, 5, 1 ] )
gap> Position(enum, last);
1368
gap> ForAll([1..2640], x-> Position(enum, enum[x])=x);
true
gap> for i in enum do od;
#gap> time;
#12
gap> AsSet(enum)=AsSSortedList(r); 
true
gap> Set(List(AsSSortedList(r), x-> Position(enum, x)))=[1..2640];
#gap> time;
#40
gap> ForAll(AsSSortedList(r), x-> x in r);;
true
#gap> time;
#31
gap> s:=Semigroup(gens);
<semigroup with 8 generators>
gap> r:=RClass(s, Transformation( [ 3, 5, 2, 2, 3, 5, 2, 3 ] ));
{Transformation( [ 3, 5, 2, 2, 3, 5, 2, 3 ] )}
gap> enum:=Enumerator(r);;
gap> ForAll([1..Length(enum)], x-> Position(enum, enum[x])=x);
true
gap> ForAll(enum, x-> x in enum);                              
true
gap> AsSet(enum)=AsSSortedList(r);
true
gap> AsList(enum)=AsSSortedList(r);
false
gap> Size(enum);
330
gap> Size(r);
330
gap> ForAll(r, x-> x in enum);
true
gap> rr:=RClass(s, Random(r));
{Transformation( [ 3, 5, 2, 2, 3, 5, 2, 3 ] )}
gap> ForAll(rr, x-> x in enum);
true
gap> Set(List(rr, x-> Position(enum, x)))=[1..Length(enum)];
true
gap> rr:=RClass(s, Transformation( [ 5, 1, 5, 3, 8, 1, 5, 7 ] ));
{Transformation( [ 5, 1, 5, 3, 8, 1, 5, 7 ] )}
gap> ForAny(rr, x-> x in enum);
false
gap> ForAny(rr, x-> not Position(enum, x)=fail);
false
gap> ForAll(rr, x->  Position(enum, x)=fail);   
true
gap> f:=Transformation( [ 2, 2, 6, 4, 1, 6, 3, 2 ] );;
gap> s:=Semigroup(gens);
<semigroup with 8 generators>
gap> r:=GreensRClassOfElementNC(s, f);
{Transformation( [ 2, 2, 6, 4, 1, 6, 3, 2 ] )}
gap> Size(r);
2640
gap> enum:=Enumerator(r);
<enumerator of R-class>
gap> enum[1];
Transformation( [ 2, 2, 6, 4, 1, 6, 3, 2 ] )
gap> enum[1000];
Transformation( [ 1, 1, 5, 4, 7, 5, 8, 1 ] )
gap> Position(enum, last);
1000
gap> ForAll([1..2640], x-> Position(enum, enum[x])=x);
true
gap> AsSet(enum)=AsSSortedList(r); 
true
gap> Set(List(AsSSortedList(r), x-> Position(enum, x)))=[1..2640];
true
gap> ForAll(AsSSortedList(r), x-> x in enum);;
true
gap> STOP_TEST( "r.tst 4.0", 10000);