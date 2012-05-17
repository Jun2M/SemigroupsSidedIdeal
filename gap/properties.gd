#############################################################################
##
#W  properties.gd
#Y  Copyright (C) 2011-12                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# properties marked JDM have filter IsTransformationSemigroup so that Citrus
# and Smallsemi can be loaded together. These should be changed back to
# IsSemigroup when a permanent solution can be found. 

DeclareAttribute("AntiIsomorphismTransformationSemigroup",
 IsSemigroup);
DeclareAttribute("GroupOfUnits", IsSemigroup);
DeclareAttribute("IdempotentGeneratedSubsemigp", IsSemigroup);
DeclareAttribute("InjectionPrincipalFactor", IsGreensDClass);
DeclareOperation("IrredundantGeneratingSubset", [IsTransformationCollection]);
DeclareProperty("IsAbundantSemigroup", IsSemigroup);
DeclareProperty("IsAdequateSemigroup", IsSemigroup);
DeclareProperty("IsBand", IsTransformationSemigroup); #JDM
DeclareProperty("IsBlockGroup", IsSemigroup);
DeclareProperty("IsBrandtSemigroup", IsTransformationSemigroup); #JDM
DeclareProperty("IsCliffordSemigroup", IsTransformationSemigroup);#JDM
DeclareProperty("IsCommutativeSemigroup", IsSemigroup);
DeclareProperty("IsCompletelyRegularSemigroup", IsTransformationSemigroup);
#JDM
DeclareProperty("IsCompletelySimpleSemigroup", IsTransformationSemigroup); #JDM
DeclareProperty("IsRTrivial", IsSemigroup);
DeclareProperty("IsLTrivial", IsSemigroup);
DeclareProperty("IsHTrivial", IsSemigroup);
DeclareSynonymAttr("IsDTrivial", IsRTrivial and IsLTrivial);
DeclareSynonymAttr("IsAperiodicSemigroup", IsHTrivial);
DeclareSynonymAttr("IsCombinatorialSemigroup", IsHTrivial);
DeclareProperty("IsFactorisableSemigroup", IsSemigroup);
DeclareProperty("IsGroupAsSemigroup", IsSemigroup);
DeclareProperty("IsIdempotentGenerated", IsTransformationSemigroup); #JDM
DeclareProperty("IsInverseMonoid", IsInverseSemigroup);
DeclareProperty("IsLeftSimple", IsSemigroup);
DeclareProperty("IsLeftZeroSemigroup", IsTransformationSemigroup); #JDm
DeclareProperty("IsMonogenicInverseSemigroup", IsSemigroup);
DeclareProperty("IsMonogenicSemigroup", IsTransformationSemigroup); #JDM
DeclareProperty("IsMonoidAsSemigroup", IsTransformationSemigroup); #JDM
DeclareOperation("IsomorphismPartialPermMonoid", [IsPermGroup]);
DeclareOperation("IsomorphismPartialPermSemigroup", [IsPermGroup]);
DeclareOperation("IsomorphismTransformationMonoid",
 [IsSemigroup]);
DeclareProperty("IsOrthodoxSemigroup", IsSemigroup);
DeclareSynonymAttr("IsPartialPermSemigroup", IsSemigroup and
IsPartialPermCollection);
DeclareProperty("IsPartialPermMonoid", IsPartialPermSemigroup);
DeclareProperty("IsRectangularBand", IsTransformationSemigroup); #JDM
DeclareProperty("IsRightSimple", IsSemigroup);
DeclareProperty("IsRightZeroSemigroup", IsTransformationSemigroup); #JDM
DeclareProperty("IsSemiband", IsTransformationSemigroup); #JDM
DeclareSynonymAttr("IsSemigroupWithCommutingIdempotents", IsBlockGroup);
DeclareProperty("IsSemilatticeAsSemigroup", IsTransformationSemigroup); #JDM
DeclareProperty("IsSynchronizingSemigroup", IsTransformationSemigroup);
DeclareProperty("IsUnitRegularSemigroup", IsSemigroup);
DeclareProperty("IsZeroRectangularBand", IsSemigroup);
DeclareProperty("IsZeroSemigroup", IsTransformationSemigroup); #JDM
DeclareAttribute("MinimalIdeal", IsSemigroup);
DeclareOperation("NrElementsOfRank", [IsSemigroup and
HasGeneratorsOfSemigroup, IsPosInt]);
DeclareAttribute("PosetOfIdempotents", IsSemigroup);
DeclareAttribute("PrimitiveIdempotents", IsInverseSemigroup);
DeclareAttribute("PrincipalFactor", IsGreensDClass);
DeclareOperation("RedundantGenerator", [IsTransformationCollection]);
DeclareGlobalFunction("ReesMatrixSemigroupElementNC");
DeclareGlobalFunction("ReesZeroMatrixSemigroupElementNC");
DeclareAttribute("SmallGeneratingSet", IsSemigroup);

InstallTrueMethod(IsAbundantSemigroup, IsRegularSemigroup);
InstallTrueMethod(IsAdequateSemigroup, IsAbundantSemigroup and IsBlockGroup);
InstallTrueMethod(IsBlockGroup, IsInverseSemigroup);
InstallTrueMethod(IsBand, IsSemilatticeAsSemigroup);
InstallTrueMethod(IsBrandtSemigroup, IsInverseSemigroup and IsZeroSimpleSemigroup);
InstallTrueMethod(IsCliffordSemigroup, IsSemilatticeAsSemigroup);
InstallTrueMethod(IsCompletelyRegularSemigroup, IsCliffordSemigroup);
InstallTrueMethod(IsCompletelyRegularSemigroup, IsSimpleSemigroup);
InstallTrueMethod(IsCompletelySimpleSemigroup, IsSimpleSemigroup and IsFinite);
InstallTrueMethod(IsDTrivial, IsSemilatticeAsSemigroup);
InstallTrueMethod(IsGroupAsSemigroup, IsInverseSemigroup and IsSimpleSemigroup);
InstallTrueMethod(IsHTrivial, IsLTrivial);
InstallTrueMethod(IsHTrivial, IsRTrivial);
InstallTrueMethod(IsIdempotentGenerated, IsSemilatticeAsSemigroup);
InstallTrueMethod(IsInverseMonoid, IsInverseSemigroup and IsMonoid);
InstallTrueMethod(IsInverseSemigroup, IsSemilatticeAsSemigroup);
InstallTrueMethod(IsInverseSemigroup, IsCliffordSemigroup);
InstallTrueMethod(IsLeftSimple, IsInverseSemigroup and IsGroupAsSemigroup);
InstallTrueMethod(IsLeftZeroSemigroup, IsInverseSemigroup and IsTrivial);
InstallTrueMethod(IsLTrivial, IsInverseSemigroup and IsRTrivial);
InstallTrueMethod(IsLTrivial, IsDTrivial);
InstallTrueMethod(IsMonoidAsSemigroup, IsGroupAsSemigroup);
InstallTrueMethod(IsOrthodoxSemigroup, IsInverseSemigroup);
InstallTrueMethod(IsRectangularBand, IsHTrivial and IsSimpleSemigroup);
InstallTrueMethod(IsRegularSemigroup, IsInverseSemigroup);
InstallTrueMethod(IsRegularSemigroup, IsSimpleSemigroup);
InstallTrueMethod(IsRightSimple, IsInverseSemigroup and IsGroupAsSemigroup);
InstallTrueMethod(IsRightZeroSemigroup, IsInverseSemigroup and IsTrivial);
InstallTrueMethod(IsRTrivial, IsInverseSemigroup and IsLTrivial);
InstallTrueMethod(IsRTrivial, IsDTrivial);
InstallTrueMethod(IsSemiband, IsIdempotentGenerated);
InstallTrueMethod(IsSemilatticeAsSemigroup, IsDTrivial and IsInverseSemigroup);
InstallTrueMethod(IsSemilatticeAsSemigroup, IsCommutative and IsBand);
InstallTrueMethod(IsSimpleSemigroup, IsGroupAsSemigroup);
InstallTrueMethod(IsZeroSemigroup, IsInverseSemigroup and IsTrivial);
InstallTrueMethod(IsMonogenicInverseSemigroup, IsInverseSemigroup and IsMonogenicSemigroup);
InstallTrueMethod(IsZeroRectangularBand, IsZeroGroup);
InstallTrueMethod(IsZeroGroup, IsZeroRectangularBand and IsInverseSemigroup);

#EOF
