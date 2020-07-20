//
//  Document.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2019/8/30.
//  Copyright © 2020 Ed Pichon.
//

/* This file is part of the SRCombatTool, by Ed Pichon
 
 SRCombatTool is free software: you can redistribute it and/or modify
 it under the terms of the Creative Commons 4.0 license - BY-NC-SA.
 
 SRCombatTool is distributed in the hope that it will be useful,
 but without any warranty.
 
 */

/*
 This is the primary document code, and where most of the UI manipulation takes place.
 I'm (obviously) not a very sklled cocoa programmer, so I haven't stuck too closely to the "MVC" paradigm. It works,
 which is good enoguh for me.
 
 The kludgey bits are status bits, which are not very elegant. I tried using a separate array controller, but I just couldn't make it work.

 */

#import <Cocoa/Cocoa.h>
@class SRDice;
@class SR6Actor;
@class ActorArrayController;
@class ImagePanelController;

@interface Document : NSPersistentDocument <NSTableViewDelegate, NSTableViewDataSource, NSComboBoxDelegate, NSComboBoxDataSource, NSTextViewDelegate, NSMenuDelegate> {
    NSArray *modeValues;
    NSArray *typeValues;
    NSArray *categoryValues;
    NSArray *drainAttrValues;
    NSArray *attributeValues;
    NSArray *augGradeValues;
    NSArray *commlinkValues;
    NSArray *cyberdeckValues;
    NSArray *cyberjackValues;
    NSArray *rccValues;
    NSRange pastedRange;
    NSInteger poSkill;
    
    ImagePanelController *imagePanelController;
    
    IBOutlet NSPopUpButton *modePopUp;
    
    SRDice *dieRoller;
    
    SR6Actor *statusSource;
    
    IBOutlet ActorArrayController *myActorArray;
    NSTouchBar *myTouchBar;
    
    // UI Element outlet interfaces
    IBOutlet NSTextField *rollField;
    IBOutlet NSSlider *rollSlider;
    IBOutlet NSTextField *rollResult;
    IBOutlet NSButton *buttonWildDie;
    IBOutlet NSButton *buttonTwosGlitch;
    IBOutlet NSButton *buttonExplodeSixes;
    IBOutlet NSButton *buttonRerollOneHit;
    IBOutlet NSButton *buttonRerollOneGlitch;
    IBOutlet NSButton *buttonRerollOneMiss;
    IBOutlet NSButton *buttonAddOnetoGlitch;
    IBOutlet NSButton *buttonAddOnetoMiss;
    IBOutlet NSButton *buttonRerollFailures;
    IBOutlet NSTableView *statusTableView;
    IBOutlet NSButton *buttonAddStatus;
    IBOutlet NSButton *buttonRemoveStatus;
    IBOutlet NSButton *buttonStatusDurationRounds;
    IBOutlet NSButton *buttonStatusDurationIndefinite;
    IBOutlet NSButton *buttonStatusCopy;
    IBOutlet NSButton *buttonStatusPaste;
    
    IBOutlet NSTextField *textStatusDuration;
    IBOutlet NSStepper *stepperStatusDurationRounds;
    IBOutlet NSTextField *textStatusRating;
    IBOutlet NSStepper *stepperStatusRating;
    IBOutlet NSComboBox *comboBoxStatus;
    IBOutlet NSTextField *labelRating;
    IBOutlet NSTextField *labelStatusDesc;
    IBOutlet NSTableView *actorTableView;

    IBOutlet NSTextView *rollLog;
    
    IBOutlet NSComboBox *cbActorType;
    IBOutlet NSPopUpButton *puMetatype;
    
    
    IBOutlet NSTextField *labelBody;
    IBOutlet NSTextField *textBody;
    
    IBOutlet NSTextField *labelMagicResonance;
    IBOutlet NSTextField *labelLevelRating;
    
    IBOutlet NSButton *buttonFWDamageResistance;
    IBOutlet NSButton *buttonBodyDamageResistance;
    IBOutlet NSButton *buttonDrainDamageResistance;
    IBOutlet NSButton *buttonRollWillSleaze;
    IBOutlet NSButton *buttonRollWillFW;
    IBOutlet NSButton *buttonRollDPFW;
    IBOutlet NSTextField *txtNumHits;
    
    IBOutlet NSBox *boxAttributes;
    IBOutlet NSBox *boxMatrixAttributes;
    IBOutlet NSBox *boxVehicleAttributes;
    
    IBOutlet NSTextField *labelDrainAttribute;
    IBOutlet NSPopUpButton *listDrainAttribute;
    
    IBOutlet NSTextField *textAttrBody;
    IBOutlet NSStepper *stAttrBody;
    IBOutlet NSTextField *textAttrAgility;
    IBOutlet NSStepper *stAttrAgility;
    IBOutlet NSTextField *textAttrReaction;
    IBOutlet NSStepper *stAttrReaction;
    IBOutlet NSTextField *textAttrStrength;
    IBOutlet NSStepper *stAttrStrength;
    IBOutlet NSTextField *textAttrWillpower;
    IBOutlet NSStepper *stAttrWillpower;
    IBOutlet NSTextField *textAttrLogic;
    IBOutlet NSStepper *stAttrLogic;
    IBOutlet NSTextField *textAttrIntuition;
    IBOutlet NSStepper *stAttrIntuition;
    IBOutlet NSTextField *textAttrCharisma;
    IBOutlet NSStepper *stAttrCharisma;
    IBOutlet NSTextField *textAttrMagic;
    IBOutlet NSStepper *stAttrMagic;
    
    IBOutlet NSTextField *textAttrResonance;
    IBOutlet NSStepper *stAttrResonance;
    
    IBOutlet NSTextField *textAttrEssence;
    IBOutlet NSTextField *textAttrEdge;
    IBOutlet NSStepper *stAttrEdge;
    
    IBOutlet NSTextField *textSkillAstral;
    IBOutlet NSStepper *stSkillAstral;
    IBOutlet NSTextField *textSkillAthletics;
    IBOutlet NSStepper *stSkillAthletics;
    IBOutlet NSTextField *textSkillBiotech;
    IBOutlet NSStepper *stSkillBiotech;
    IBOutlet NSTextField *textSkillCloseCombat;
    IBOutlet NSStepper *stSkillCloseCombat;
    IBOutlet NSTextField *textSkillCon;
    IBOutlet NSStepper *stSkillCon;
    IBOutlet NSTextField *textSkillConjuring;
    IBOutlet NSStepper *stSkillConjuring;
    IBOutlet NSTextField *textSkillCracking;
    IBOutlet NSStepper *stSkillCracking;
    IBOutlet NSTextField *textSkillElectronics;
    IBOutlet NSStepper *stSkillElectronics;
    IBOutlet NSTextField *textSkillEnchanting;
    IBOutlet NSStepper *stSkillEnchanting;
    IBOutlet NSTextField *textSkillEngineering;
    IBOutlet NSStepper *stSkillEngineering;
    IBOutlet NSTextField *textSkillExoticWeapons;
    IBOutlet NSStepper *stSkillExoticWeapons;
    IBOutlet NSTextField *textSkillFirearms;
    IBOutlet NSStepper *stSkillFirearms;
    IBOutlet NSTextField *textSkillInfluence;
    IBOutlet NSStepper *stSkillInfluence;
    IBOutlet NSTextField *textSkillOutdoors;
    IBOutlet NSStepper *stSkillOutdoors;
    IBOutlet NSTextField *textSkillPerception;
    IBOutlet NSStepper *stSkillPerception;
    IBOutlet NSTextField *textSkillPilot;
    IBOutlet NSStepper *stSkillPilot;
    IBOutlet NSTextField *textSkillSorcery;
    IBOutlet NSStepper *stSkillSorcery;
    IBOutlet NSTextField *textSkillStealth;
    IBOutlet NSStepper *stSkillStealth;
    IBOutlet NSTextField *textSkillTasking;
    IBOutlet NSStepper *stSkillTasking;
    IBOutlet NSTextField *textSkillOther;
    IBOutlet NSStepper *stSkillOther;
    
    IBOutlet NSTextField *textMatrixDeviceRating;
    IBOutlet NSStepper *stMatrixDeviceRating;
    IBOutlet NSTextField *textMatrixAttack;
    IBOutlet NSStepper *stMatrixAttack;
    IBOutlet NSTextField *textMatrixSleaze;
    IBOutlet NSStepper *stMatrixSleaze;
    IBOutlet NSTextField *textMatrixDataProcessing;
    IBOutlet NSStepper *stMatrixDataProcessing;
    IBOutlet NSTextField *textMatrixFirewall;
    IBOutlet NSStepper *stMatrixFirewall;
    IBOutlet NSTextField * textMatrixInit;
    IBOutlet NSStepper * stMatrixInit;
    IBOutlet NSTextField *textCMMatrix;
    IBOutlet NSStepper * stCMMatrix;
    IBOutlet NSTextField *textMatrixDefenseRating;
    IBOutlet NSStepper *stMatrixDefenseRating;
    IBOutlet NSTextField *textMatrixAttackRating;
    IBOutlet NSStepper *stMatrixAttackRating;
    IBOutlet NSTextField *textMatrixDefenseRating2;
    IBOutlet NSStepper *stMatrixDefenseRating2;
    IBOutlet NSTextField *textMatrixAttackRating2;
    IBOutlet NSStepper *stMatrixAttackRating2;
    
    IBOutlet NSTextField *textMatrixAttack2;
    IBOutlet NSStepper *stMatrixAttack2;
    IBOutlet NSTextField *textMatrixSleaze2;
    IBOutlet NSStepper *stMatrixSleaze2;
    IBOutlet NSTextField *textMatrixDataProcessing2;
    IBOutlet NSStepper *stMatrixDataProcessing2;
    IBOutlet NSTextField *textMatrixFirewall2;
    IBOutlet NSStepper *stMatrixFirewall2;
    IBOutlet NSTextField * textMatrixInit2;
    IBOutlet NSStepper * stMatrixInit2;
    IBOutlet NSTextField *textCMMatrix2;
    IBOutlet NSStepper * stCMMatrix2;
    
    
    IBOutlet NSTextField * textPhysicalInit;
    IBOutlet NSStepper * stPhysicalInit;
    IBOutlet NSTextField * textAstralInit;
    IBOutlet NSStepper * stAstralInit;
    
    IBOutlet NSTextField *textCMStun;
    IBOutlet NSStepper * stCMStun;
    IBOutlet NSTextField *textCMPhysical;
    IBOutlet NSStepper * stCMPhysical;
    
    
    IBOutlet NSTextField *textDefenseRating;
    IBOutlet NSStepper *stDefenseRating;
    
    IBOutlet NSScrollView *scrollViewLog;
    IBOutlet NSTextView *textViewLog;
    IBOutlet NSImageView *imageViewer;
    
    IBOutlet NSStepper *stSpeed;
    
    IBOutlet NSTextView *textViewDetails;
    IBOutlet NSTabView *tabView;
    IBOutlet NSTabViewItem *tabStats;
    IBOutlet NSTabViewItem *tabQualities;
    IBOutlet NSTabViewItem *tabAugs;
    IBOutlet NSTabViewItem *tabWeapons;
    IBOutlet NSTabViewItem *tabMagic;
    IBOutlet NSTabViewItem *tabAdepts;
    IBOutlet NSTabViewItem *tabSpells;
    IBOutlet NSTabViewItem *tabPowers;
    IBOutlet NSTabViewItem *tabMatrix;
    IBOutlet NSTabViewItem *tabTechnomancers;
    IBOutlet NSTabViewItem *tabComplexForms;
    IBOutlet NSTabViewItem *tabInfo;
    IBOutlet NSTabViewItem *tabImages;
    
    IBOutlet NSPopover *poRollSkillOptions;
    IBOutlet NSPopover *poRollAttrOptions;
    IBOutlet NSPopUpButton *puAttr;
    IBOutlet NSPopUpButton *puFirstAttr;
    IBOutlet NSPopUpButton *puSecondAttr;
    IBOutlet NSButton *cbDmgMods;
    IBOutlet NSButton *cbMatrixMods;
    IBOutlet NSButton *cbStatusMods;
    IBOutlet NSButton *cbDmgModsAttr;
    IBOutlet NSButton *cbMatrixModsAttr;
    IBOutlet NSButton *cbStatusModsAttr;
    
    IBOutlet NSButton *rbNoSpec;
    IBOutlet NSButton *rbSpec;
    IBOutlet NSButton *rbExp;
    
    IBOutlet NSPopover *poAddAdeptPower;
    IBOutlet NSTableView *adeptPowerPickerTableView;
    IBOutlet NSArrayController *adeptPowersSourceArray;
    IBOutlet NSTableView *adeptPowerTableView;
    IBOutlet NSTextField *lblTotalPowerPoints;
    
    IBOutlet NSPopover *poAddAug;
    IBOutlet NSTableView *augPickerTableView;
    IBOutlet NSArrayController *augsSourceArray;
    IBOutlet NSTableView *augTableView;
    IBOutlet NSTextField *lblTotalEssence;
    
    IBOutlet NSPopover *poAddComplexForm;
    IBOutlet NSTableView *complexFormPickerTableView;
    IBOutlet NSArrayController *complexFormsSourceArray;
    IBOutlet NSTableView *complexFormTableView;
    IBOutlet NSTextField *lblCFsSustained;
    
    IBOutlet NSPopover *poAddEcho;
    IBOutlet NSTableView *echoPickerTableView;
    IBOutlet NSArrayController *echoesSourceArray;
    IBOutlet NSTableView *echoTableView;

    IBOutlet NSArrayController *mentorsSourceArray;
    
    IBOutlet NSPopover *poAddMetamagic;
    IBOutlet NSTableView *metamagicPickerTableView;
    IBOutlet NSArrayController *metamagicsSourceArray;
    IBOutlet NSTableView *metamagicTableView;
    
    IBOutlet NSPopover *poAddPower;
    IBOutlet NSTableView *powerPickerTableView;
    IBOutlet NSArrayController *powersSourceArray;
    IBOutlet NSTableView *powerTableView;
    
    IBOutlet NSPopover *poAddProgram;
    IBOutlet NSTableView *programPickerTableView;
    IBOutlet NSArrayController *programsSourceArray;
    IBOutlet NSTableView *programTableView;
    IBOutlet NSTextField *lblProgramsRunning;
    
    IBOutlet NSPopover *poAddQuality;
    IBOutlet NSTableView *qualityPickerTableView;
    IBOutlet NSArrayController *qualitiesSourceArray;
    IBOutlet NSTableView *qualityTableView;
    IBOutlet NSTextField *lblTotalKarma;
    
    IBOutlet NSPopover *poAddSpell;
    IBOutlet NSTableView *spellPickerTableView;
    IBOutlet NSArrayController *spellsSourceArray;
    IBOutlet NSTableView *spellTableView;
    IBOutlet NSTextField *lblTotalSpellsSustained;
    
    IBOutlet NSPopover *poAddWeapon;
    IBOutlet NSTableView *weaponPickerTableView;
    IBOutlet NSArrayController *weaponsSourceArray;
    IBOutlet NSTableView *weaponTableView;
    IBOutlet NSArrayController *weaponsArray;
}

- (IBAction) rollDice: (id _Nullable ) sender;
- (IBAction) reRollOneHit: (id _Nullable ) sender;
- (IBAction) reRollOneGlitch: (id _Nullable ) sender;
- (IBAction) reRollOneMiss: (id _Nullable ) sender;
- (IBAction) reRollFailures: (id _Nullable ) sender;
- (IBAction) addOnetoGlitch: (id _Nullable) sender;
- (IBAction) addOnetoMiss: (id _Nullable ) sender;
- (IBAction) rollSum:(id _Nullable)sender;
- (IBAction) cbActorTypeEdited:(id _Nullable)sender;
- (void) rollDice: (id _Nullable) sender rollDesc:(NSString *_Nullable) rollDesc;

-(IBAction) addStatus: (id _Nullable) sender;
-(IBAction) removeStatus: (id _Nullable) sender;
-(IBAction) radioDuration: (id _Nullable)sender;

- (IBAction)pasteAndMatchStyle:(id _Nullable)sender;

- (void)rollAttrTest:(NSInteger)firstAttr secondAttr:(NSInteger) secondAttr withDmgMods:(BOOL)dmgMods withMatrixMods:(BOOL)matrixMods withStatusMods:(BOOL)statusMods withName:(nullable NSString *)rollName;

- (IBAction)rollBodDmgResist:(id _Nullable)sender;
- (IBAction)rollFWDmgResist:(id _Nullable)sender;
- (IBAction)rollDrainDmgResist:(id _Nullable)sender;
- (IBAction)rollMemory:(id _Nullable)sender;
- (IBAction)rollComposure:(id _Nullable)sender;
- (IBAction)rollJudgeIntentions:(id _Nullable)sender;
- (IBAction)rollInitative:(id _Nullable)sender;
- (IBAction)rollElectronicsInt:(id _Nullable)sender;
- (IBAction)rollPerception:(id _Nullable)sender;
- (IBAction)rollSurprise:(id _Nullable)sender;
- (IBAction)rollWillInt:(id _Nullable)sender;
- (IBAction)rollWillRx:(id _Nullable)sender;
- (IBAction)rollWillSleaze:(id _Nullable)sender;
- (IBAction)rollWillFW:(id _Nullable)sender;
- (IBAction)rollDPFW:(id _Nullable)sender;
- (IBAction)rollRxInt:(id _Nullable)sender;
- (IBAction)stAddStun:(id _Nullable)sender;
- (IBAction)stAddPhysical:(id _Nullable)sender;

- (IBAction)imageBrowse:(id _Nullable)sender;
- (IBAction)imageZoom:(id _Nullable)sender;

- (IBAction)accelClicked:(id _Nullable)sender;

- (IBAction)showSkillPopover:(id _Nullable)sender;
- (IBAction)showAttrPopover:(id _Nullable)sender;
- (IBAction)radioSpecClicked:(id _Nullable)sender;

- (IBAction)poRollSkillClicked:(id _Nullable)sender;
- (IBAction)poRollAttrClicked:(id _Nullable)sender;
- (IBAction)makeAttack:(id _Nullable)sender;
- (IBAction)showSpellPopover:(id _Nullable)sender;
- (IBAction)showQualityPopover:(id _Nullable)sender;
- (IBAction)showWeaponPopover:(id _Nullable)sender;

@property (readwrite, strong) NSArray * _Nonnull modeValues;
@property (readwrite, strong) NSArray * _Nonnull typeValues;
@property (readwrite, strong) NSArray * _Nonnull categoryValues;
@property (readwrite, strong) NSArray * _Nonnull drainAttrValues;
@property (readwrite, strong) NSArray * _Nonnull attributeValues;
@property (readwrite, strong) NSArray * _Nonnull augGradeValues;
@property (readwrite, strong) NSArray * _Nonnull metatypeValues;
@property (readwrite, strong) NSArray * _Nonnull commlinkValues;
@property (readwrite, strong) NSArray * _Nonnull cyberjackValues;
@property (readwrite, strong) NSArray * _Nonnull cyberdeckValues;
@property (readwrite, strong) NSArray * _Nonnull ammoTypeValues;
@property (readwrite, strong) NSArray * _Nonnull weaponFiringModeValues;
@property (readwrite, strong) NSArray * _Nonnull rccValues;
@property (readwrite, strong) NSTouchBar * _Nonnull myTouchBar;
@property (readwrite) NSNumber * _Nonnull dicePool;
@property (readonly) BOOL canMakeNextActive;
@property (readonly) NSArray * _Nonnull mentorSorters;

@property (strong) NSMutableAttributedString * _Nonnull log;

// Copy/paste support
-(IBAction) cut: (id _Nullable)sender;
-(IBAction) copy: (id _Nullable)sender;
-(IBAction) paste: (id _Nullable)sender;

- (IBAction)poAdeptPowerAddClicked:(id _Nullable)sender;
- (IBAction)removeAdeptPower:(id _Nullable)sender;
- (IBAction)adeptPowerLevelChange:(id _Nullable)sender;

- (IBAction)poAugAddClicked:(id _Nullable)sender;
- (IBAction)removeAug:(id _Nullable)sender;
- (IBAction)augGradeChanged:(id _Nullable)sender;
- (IBAction)augRatingChanged:(id _Nullable)sender;

- (IBAction)poComplexFormAddClicked:(id _Nullable)sender;
- (IBAction)removeComplexForm:(id _Nullable)sender;
- (IBAction)sustainedComplexFormsChanged:(id _Nullable)sender;

- (IBAction)poEchoAddClicked:(id _Nullable)sender;
- (IBAction)removeEcho:(id _Nullable)sender;

- (IBAction)poMetamagicAddClicked:(id _Nullable)sender;
- (IBAction)removeMetamagic:(id _Nullable)sender;
 
- (IBAction)poPowerAddClicked:(id _Nullable)sender;
- (IBAction)removePower:(id _Nullable)sender;

- (IBAction)poProgramAddClicked:(id _Nullable)sender;
- (IBAction)removeProgram:(id _Nullable)sender;

- (IBAction)poQualityAddClicked:(id _Nullable)sender;
- (IBAction)removeQuality:(id _Nullable)sender;
- (IBAction)qualitiesChanged:(id _Nullable)sender;

- (IBAction)poSpellAddClicked:(id _Nullable)sender;
- (IBAction)removeSpell:(id _Nullable)sender;
- (IBAction)sustainedSpellsChanged:(id _Nullable)sender;

- (IBAction)poWeaponAddClicked:(id _Nullable)sender;
- (IBAction)removeWeapon:(id _Nullable)sender;

- (IBAction)resetWeaponAccessories:(id _Nullable)sender;
- (IBAction)reloadWeapon:(id _Nullable)sender;

- (IBAction)addNewActor:(id _Nullable) sender;




@end
