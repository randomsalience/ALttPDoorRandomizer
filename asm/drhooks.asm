org $02b5c4 ; -- moving right routine 135c4
jsl WarpRight
org $02b665 ; -- moving left routine
jsl WarpLeft
org $02b713 ; -- moving down routine
jsl WarpDown
org $02b7b4 ; -- moving up routine
jsl WarpUp
org $02bd80
jsl AdjustTransition
nop

;turn off linking doors -- see .notRoomLinkDoor label in Bank02.asm
org $02b5a8 ; <- 135a8 - Bank02.asm : 8368 (LDA $7EC004 : STA $A0)
jsl CheckLinkDoorR
bcc NotLinkDoor1
org $02b5b6
NotLinkDoor1:
org $02b649 ; <- 135a8 - Bank02.asm : 8482 (LDA $7EC004 : STA $A0)
jsl CheckLinkDoorL
bcc NotLinkDoor2
org $02b657
NotLinkDoor2:


; Staircase routine
org $01c3d4 ;(PC: c3d4)
jsl RecordStairType : nop
org $02a1e7 ;(PC: 121e7)
jsl SpiralWarp


; Graphics fix
org $02895d
Splicer:
jsl GfxFixer
lda $b1 : beq .done
rts
nop #5
.done

org $00fda4
Dungeon_InitStarTileCh:
org $00d6ae ;(PC: 56ae)
LoadTransAuxGfx:
org $00df5a ;(PC: 5f5a)
PrepTransAuxGfx:
org $0ffd65 ;(PC: 07fd65)
Dungeon_LoadCustomTileAttr:
;org $01fec1
;Dungeon_ApproachFixedColor_variable:
;org $a0f972 ; Rando version
;LoadRoomHook:
org $1bee74 ;(PC: 0dee74)
Palette_DungBgMain:
org $1bec77
Palette_SpriteAux3:
org $1becc5
Palette_SpriteAux2:
org $1bece4
Palette_SpriteAux1:


org $0DFA53
jsl.l LampCheckOverride
org $028046 ; <- 10046 - Bank02.asm : 217 (JSL EnableForceBlank) (Start of Module_LoadFile)
jsl.l OnFileLoadOverride
org $07A93F  ; < 3A93F - Bank07.asm 6548 (LDA $8A : AND.b #$40 - Mirror checks)
jsl.l MirrorCheckOverride

org $05ef47
Sprite_HeartContainer_Override: ;sprite_heart_upgrades.asm : 96-100 (LDA $040C : CMP.b #$1A : BNE .not_in_ganons_tower)
jsl GtBossHeartCheckOverride : bcs .not_in_ganons_tower
nop : stz $0dd0, X : rts
.not_in_ganons_tower


org $2081f2
jsl MirrorCheckOverride2
org $20825c
jsl MirrorCheckOverride2
org $07a955 ; <- Bank07.asm : around 6564 (JP is a bit different) (STZ $05FC : STZ $05FD)
jsl BlockEraseFix
nop #2

org $02b82a
jsl FixShopCode

org $1ddeea ; <- Bank1D.asm : 286 (JSL Sprite_LoadProperties)
jsl VitreousKeyReset

org $1ed024 ;  f5024 sprite_guruguru_bar.asm : 27 (LDA $040C : CMP.b #$12 : INY #2
jsl GuruguruFix : bra .next
nop #3
.next

; also rando's hooks.asm line 1360
org $a0ee11 ; <- 6FC4C - headsup_display.asm : 836 (LDA $7EF36E : AND.w #$00FF : ADD.w #$0007 : AND.w #$FFF8 : TAX)
jsl DrHudOverride
org $098638 ; rando's hooks.asm line 2192
jsl CountChestKeys
org $06D192 ; rando's hooks.asm line 457
jsl CountAbsorbedKeys
; rando's hooks.asm line 1020
org $05FC7E ; <- 2FC7E - sprite_dash_item.asm : 118 (LDA $7EF36F : INC A : STA $7EF36F)
jsl CountBonkItem

; These two, if enabled together, have implications for vanilla BK doors in IP/Hera/Mire
; IPBJ is common enough to consider not doing this. Mire is not a concern for vanilla - maybe glitched modes
; Hera BK door back can be seen with Pot clipping - likely useful for no logic seeds

;Kill big key (1e) check for south doors
;org $1aa90
;DontCheck:
;bra .done
;nop #3
;.done

;Enable south facing bk graphic
;org $4e24
;dw $2ac8

org $01b714 ; PC: b714
OpenableDoors:
jsl CheckIfDoorsOpen
bcs .normal
rts
.normal
