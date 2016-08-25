import flask_sqlalchemy
from sqlalchemy.dialects import postgresql as pg

db = flask_sqlalchemy.SQLAlchemy()

RarityEnum = pg.ENUM('Common', 'Rare', 'Not For Sale', name='rarity', metadata=db.metadata)
BodyAreasEnum = pg.ENUM('Head', 'Neck', 'Upper Chest', 'Abdomen', 'Groin', 'Upper Back',
                        'Lower Back', 'Buttocks', 'Shoulders', 'Upper Arms', 'Forearms',
                        'Hands', 'Thighs', 'Shins', 'Feet', 'Joints', name='body_areas',
                        metadata=db.metadata)
FireArcEnum = pg.ENUM('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='fire_arc',
                      metadata=db.metadata)
GenderEnum = pg.ENUM('M', 'F', name='gender', metadata=db.metadata)
PlayableTypeEnum = pg.ENUM('PC', 'NPC', 'Creature', name='playable_type', metadata=db.metadata)
LanguageAbilityEnum = pg.ENUM('Speak', 'Understand', 'None', name='language_ability',
                              metadata=db.metadata)

class Armor(db.Model):
    __tablename__ = 'armor'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    areas_covered = db.Column(pg.ARRAY(BodyAreasEnum), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    resist_physical = db.Column(db.Numeric(3, 1), nullable=False)
    resist_energy = db.Column(db.Numeric(3, 1), nullable=False)
    rarity = db.Column(RarityEnum, nullable=False, server_default=db.text("'Common'::rarity"))
    price_new = db.Column(db.SmallInteger, nullable=False)
    price_used = db.Column(db.SmallInteger, nullable=False)

    images = db.relationship('Image', secondary='armor_image')


t_armor_image = db.Table(
    'armor_image', db.metadata,
    db.Column('armor_id', db.ForeignKey('armor.id', ondelete='RESTRICT', onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('armor_id', 'image_id')
)


class Attribute(db.Model):
    __tablename__ = 'attribute'

    name = db.Column(db.String(30), nullable=False)
    id = db.Column(db.String(3), primary_key=True)
    description = db.Column(db.Text, nullable=False)
    display_order = db.Column(db.SmallInteger, nullable=False)


t_character_armor = db.Table(
    'character_armor', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('armor_id', db.ForeignKey('armor.id', ondelete='CASCADE', onupdate='RESTRICT'),
              nullable=False, index=True)
)


class CharacterAttribute(db.Model):
    __tablename__ = 'character_attribute'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    attribute = db.relationship('Attribute')
    character = db.relationship('CharacterSheet')


class CharacterSheet(db.Model):
    __tablename__ = 'character_sheet'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    race_id = db.Column(db.ForeignKey('race.id', ondelete='RESTRICT', onupdate='CASCADE'),
                        nullable=False, index=True)
    planet_id = db.Column(db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'),
                          index=True)
    character_type_id = db.Column(db.ForeignKey('character_type.id', ondelete='CASCADE',
                                                onupdate='RESTRICT'), nullable=False, index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    background = db.Column(db.Text, nullable=False)
    motivation = db.Column(db.Text, nullable=False)
    quote = db.Column(db.Text, nullable=False)
    gender = db.Column(GenderEnum, nullable=False, server_default=db.text("'M'::gender"))
    age = db.Column(db.SmallInteger, nullable=False)
    height = db.Column(db.Numeric(3, 1), nullable=False)
    weight = db.Column(db.Integer, nullable=False)
    move_land = db.Column(db.SmallInteger, nullable=False,
                          server_default=db.text("'10'::smallint"))
    move_water = db.Column(db.SmallInteger, nullable=False,
                           server_default=db.text("'0'::smallint"))
    move_air = db.Column(db.SmallInteger, nullable=False,
                         server_default=db.text("'0'::smallint"))
    force_pts = db.Column(db.SmallInteger, nullable=False)
    dark_side_pts = db.Column(db.SmallInteger, nullable=False)
    character_pts = db.Column(db.SmallInteger, nullable=False)
    credits_bank = db.Column(db.BigInteger, nullable=False)
    credits_debt = db.Column(db.BigInteger, nullable=False)
    is_template = db.Column(db.Boolean, nullable=False, server_default=db.text("false"))

    character_type = db.relationship('CharacterType')
    character_planet = db.relationship('Planet')
    character_race = db.relationship('Race')
    character_explosives = db.relationship('WeaponExplosive',
                                           secondary='character_weapon_explosive')
    character_vehicles = db.relationship('Vehicle', secondary='character_vehicle')
    character_melee_weapons = db.relationship('WeaponMelee', secondary='character_weapon_melee')
    character_starships = db.relationship('Starship', secondary='character_starship')
    character_ranged_weapons = db.relationship('WeaponRanged', secondary='character_weapon_ranged')

    images = db.relationship('Image', secondary='character_image')


t_character_image = db.Table(
    'character_image', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='RESTRICT',
                                            onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('character_id', 'image_id')
)


class CharacterSkill(db.Model):
    __tablename__ = 'character_skill'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    character = db.relationship('CharacterSheet')
    skill = db.relationship('Skill')


class CharacterSpecialization(db.Model):
    __tablename__ = 'character_specialization'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)
    specialization_id = db.Column(db.ForeignKey('skill_specialization.id', ondelete='RESTRICT',
                                                onupdate='CASCADE'), nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    character = db.relationship('CharacterSheet')
    specialization = db.relationship('SkillSpecialization')


t_character_starship = db.Table(
    'character_starship', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('starship_id', db.ForeignKey('starship.id', ondelete='CASCADE',
                                           onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterType(db.Model):
    __tablename__ = 'character_type'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    name = db.Column(db.String(50), nullable=False)


t_character_vehicle = db.Table(
    'character_vehicle', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('vehicle_id', db.ForeignKey('vehicle.id', ondelete='CASCADE', onupdate='RESTRICT'),
              nullable=False, index=True)
)


t_character_weapon_explosive = db.Table(
    'character_weapon_explosive', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_melee = db.Table(
    'character_weapon_melee', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('melee_id', db.ForeignKey('weapon_melee.id', ondelete='CASCADE',
                                        onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_ranged = db.Table(
    'character_weapon_ranged', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('ranged_id', db.ForeignKey('weapon_ranged.id', ondelete='CASCADE',
                                         onupdate='RESTRICT'), nullable=False, index=True)
)


class ForceAbility(db.Model):
    __tablename__ = 'force_ability'

    name = db.Column(db.String(100), nullable=False)
    difficulty = db.Column(db.Text, nullable=False)
    time_required = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    force_power_id = db.Column(pg.UUID)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))


class ForceAbilityPrerequisite(db.Model):
    __tablename__ = 'force_ability_prerequisite'
    __table_args__ = (
        db.UniqueConstraint('force_ability_id', 'prerequisite_id'),
    )

    force_ability_id = db.Column(pg.UUID)
    prerequisite_id = db.Column(pg.UUID)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))


class ForcePower(db.Model):
    __tablename__ = 'force_power'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)


class Image(db.Model):
    __tablename__ = 'image'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    display_order = db.Column(db.SmallInteger, nullable=False)
    name = db.Column(db.String(120), nullable=False)
    dir = db.Column(db.String(100), nullable=False)
    caption = db.Column(db.String(200), nullable=False)
    image_width = db.Column(db.SmallInteger, nullable=False)
    image_height = db.Column(db.SmallInteger, nullable=False)
    thumb_width = db.Column(db.SmallInteger, nullable=False)
    thumb_height = db.Column(db.SmallInteger, nullable=False)


class Planet(db.Model):
    __tablename__ = 'planet'

    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))

    images = db.relationship('Image', secondary='planet_image')


t_planet_image = db.Table(
    'planet_image', db.metadata,
    db.Column('planet_id', db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('planet_id', 'image_id')
)


class Race(db.Model):
    __tablename__ = 'race'

    playable_type = db.Column(PlayableTypeEnum, nullable=False, index=True,
                              server_default=db.text("'PC'::playable_type"))
    name = db.Column(db.String(100), nullable=False)
    basic_ability = db.Column(LanguageAbilityEnum, nullable=False,
                              server_default=db.text("'Speak'::language_ability"))
    description = db.Column(db.Text, nullable=False)
    special_abilities = db.Column(db.Text, nullable=False)
    story_factors = db.Column(db.Text, nullable=False)
    min_move_land = db.Column(db.SmallInteger, nullable=False,
                              server_default=db.text("'10'::smallint"))
    max_move_land = db.Column(db.SmallInteger, nullable=False,
                              server_default=db.text("'12'::smallint"))
    min_move_water = db.Column(db.SmallInteger, nullable=False,
                               server_default=db.text("'5'::smallint"))
    max_move_water = db.Column(db.SmallInteger, nullable=False,
                               server_default=db.text("'6'::smallint"))
    min_move_air = db.Column(db.SmallInteger, nullable=False,
                             server_default=db.text("'0'::smallint"))
    max_move_air = db.Column(db.SmallInteger, nullable=False,
                             server_default=db.text("'0'::smallint"))
    min_height = db.Column(db.Numeric(3, 1), nullable=False,
                           server_default=db.text("'1.5'::double precision"))
    max_height = db.Column(db.Numeric(3, 1), nullable=False,
                           server_default=db.text("'2'::double precision"))
    attribute_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("12.0"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    planet_id = db.Column(db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'))

    planet = db.relationship('Planet')
    images = db.relationship('Image', secondary='race_image')


t_race_image = db.Table(
    'race_image', db.metadata,
    db.Column('race_id', db.ForeignKey('race.id', ondelete='RESTRICT', onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('race_id', 'image_id')
)


class RaceAttribute(db.Model):
    __tablename__ = 'race_attribute'
    __table_args__ = (
        db.UniqueConstraint('race_id', 'attribute_id'),
    )

    min_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("2.0"))
    max_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("4.0"))
    race_id = db.Column(db.ForeignKey('race.id', ondelete='CASCADE', onupdate='CASCADE'),
                        nullable=False)
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))

    attribute = db.relationship('Attribute')
    race = db.relationship('Race', backref='race_attributes')


class Scale(db.Model):
    __tablename__ = 'scale'

    id = db.Column(db.String(30), primary_key=True)
    modifier = db.Column(db.Numeric(3, 1), nullable=False)


class Skill(db.Model):
    __tablename__ = 'skill'

    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    has_specializations = db.Column(db.Boolean, nullable=False, server_default=db.text("true"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT',
                                           onupdate='CASCADE'), nullable=False)

    attribute = db.relationship('Attribute')


class SkillAdvanced(db.Model):
    __tablename__ = 'skill_advanced'

    prerequisite_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("5.0"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))
    base_skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))

    base_skill = db.relationship('Skill', primaryjoin='SkillAdvanced.base_skill_id == Skill.id')
    skill = db.relationship('Skill', primaryjoin='SkillAdvanced.skill_id == Skill.id')


class SkillSpecialization(db.Model):
    __tablename__ = 'skill_specialization'

    name = db.Column(db.String(100), nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))

    skill = db.relationship('Skill')


class Starship(db.Model):
    __tablename__ = 'starship'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    scale_id = db.Column(db.ForeignKey('scale.id', ondelete='SET NULL', onupdate='RESTRICT'),
                         index=True)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    length = db.Column(db.Float(53), nullable=False)
    capacity_crew = db.Column(db.SmallInteger, nullable=False)
    capacity_passengers = db.Column(db.SmallInteger, nullable=False)
    capacity_troops = db.Column(db.SmallInteger, nullable=False)
    capacity_cargo = db.Column(db.SmallInteger, nullable=False)
    capacity_consumables = db.Column(db.SmallInteger, nullable=False)
    has_nav_computer = db.Column(db.SmallInteger, nullable=False)
    hyperdrive_multiplier = db.Column(db.Float(53), nullable=False)
    hyperdrive_backup = db.Column(db.Float(53), nullable=False)
    speed_space = db.Column(db.SmallInteger, nullable=False)
    speed_atmosphere_min = db.Column(db.SmallInteger, nullable=False)
    speed_atmosphere_max = db.Column(db.SmallInteger, nullable=False)
    maneuver = db.Column(db.Numeric(3, 1), nullable=False)
    hull = db.Column(db.Numeric(3, 1), nullable=False)
    shields = db.Column(db.Numeric(3, 1), nullable=False)
    sensors_passive_range = db.Column(db.SmallInteger, nullable=False)
    sensors_passive_level = db.Column(db.Numeric(3, 1), nullable=False)
    sensors_scan_range = db.Column(db.SmallInteger, nullable=False)
    sensors_scan_level = db.Column(db.Numeric(3, 1), nullable=False)
    sensors_search_range = db.Column(db.SmallInteger, nullable=False)
    sensors_search_level = db.Column(db.Numeric(3, 1), nullable=False)
    sensors_focus_range = db.Column(db.SmallInteger, nullable=False)
    sensors_focus_level = db.Column(db.Numeric(3, 1), nullable=False)
    rarity = db.Column(RarityEnum, nullable=False, server_default=db.text("'Common'::rarity"))
    price_new = db.Column(db.Integer)
    price_used = db.Column(db.Integer)

    scale = db.relationship('Scale')
    skill = db.relationship('Skill')

    images = db.relationship('Image', secondary='starship_image')


t_starship_image = db.Table(
    'starship_image', db.metadata,
    db.Column('starship_id', db.ForeignKey('starship.id', ondelete='RESTRICT', onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('starship_id', 'image_id')
)


class StarshipWeapon(db.Model):
    __tablename__ = 'starship_weapon'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    starship_id = db.Column(db.ForeignKey('starship.id', ondelete='CASCADE',
                                          onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control = db.Column(db.Numeric(3, 1), nullable=False)
    fire_arc = db.Column(pg.ARRAY(FireArcEnum), nullable=False)
    fire_linked = db.Column(db.SmallInteger, nullable=False)
    range_minimum_space = db.Column(db.SmallInteger, nullable=False)
    range_short_space = db.Column(db.SmallInteger, nullable=False)
    range_medium_space = db.Column(db.SmallInteger, nullable=False)
    range_long_space = db.Column(db.SmallInteger, nullable=False)
    range_minimum_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_short_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_medium_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_long_atmosphere = db.Column(db.SmallInteger, nullable=False)
    damage = db.Column(db.Numeric(3, 1), nullable=False)

    skill = db.relationship('Skill')
    starship = db.relationship('Starship')


class Vehicle(db.Model):
    __tablename__ = 'vehicle'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    scale_id = db.Column(db.ForeignKey('scale.id', ondelete='SET NULL', onupdate='RESTRICT'),
                         index=True)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    cover = db.Column(db.Float(53), nullable=False)
    capacity_crew = db.Column(db.SmallInteger, nullable=False)
    capacity_passengers = db.Column(db.SmallInteger, nullable=False)
    capacity_troops = db.Column(db.SmallInteger, nullable=False)
    capacity_cargo = db.Column(db.SmallInteger, nullable=False)
    capacity_consumables = db.Column(db.SmallInteger, nullable=False)
    speed_min = db.Column(db.SmallInteger, nullable=False)
    speed_max = db.Column(db.SmallInteger, nullable=False)
    altitude_min = db.Column(db.SmallInteger, nullable=False)
    altitude_max = db.Column(db.SmallInteger, nullable=False)
    maneuver = db.Column(db.Numeric(3, 1), nullable=False)
    hull = db.Column(db.Numeric(3, 1), nullable=False)
    shields = db.Column(db.Numeric(3, 1), nullable=False)
    rarity = db.Column(RarityEnum, nullable=False, server_default=db.text("'Common'::rarity"))
    price_new = db.Column(db.Integer)
    price_used = db.Column(db.Integer)

    scale = db.relationship('Scale')
    skill = db.relationship('Skill')

    images = db.relationship('Image', secondary='vehicle_image')


t_vehicle_image = db.Table(
    'vehicle_image', db.metadata,
    db.Column('vehicle_id', db.ForeignKey('vehicle.id', ondelete='RESTRICT', onupdate='CASCADE'),
              nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('vehicle_id', 'image_id')
)


class VehicleWeapon(db.Model):
    __tablename__ = 'vehicle_weapon'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    vehicle_id = db.Column(db.ForeignKey('vehicle.id', ondelete='CASCADE',
                                         onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control = db.Column(db.Numeric(3, 1), nullable=False)
    fire_arc = db.Column(pg.ARRAY(FireArcEnum), nullable=False)
    fire_linked = db.Column(db.SmallInteger, nullable=False)
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)
    damage = db.Column(db.Numeric(3, 1), nullable=False)

    skill = db.relationship('Skill')
    vehicle = db.relationship('Vehicle')


class WeaponExplosive(db.Model):
    __tablename__ = 'weapon_explosive'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')
    images = db.relationship('Image', secondary='weapon_explosive_image')


t_weapon_explosive_image = db.Table(
    'weapon_explosive_image', db.metadata,
    db.Column('weapon_explosive_id', db.ForeignKey('weapon_explosive.id', ondelete='RESTRICT',
                                                   onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('weapon_explosive_id', 'image_id')
)


t_weapon_explosive_damage = db.Table(
    'weapon_explosive_damage', db.metadata,
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.id', ondelete='CASCADE',
                                            onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('radius', db.SmallInteger, nullable=False),
    db.Column('damage', db.Numeric(3, 1), nullable=False)
)


class WeaponMelee(db.Model):
    __tablename__ = 'weapon_melee'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    damage = db.Column(db.Numeric(3, 1), nullable=False)
    max_damage = db.Column(db.Numeric(3, 1), nullable=False)

    skill = db.relationship('Skill')
    images = db.relationship('Image', secondary='weapon_melee_image')


t_weapon_melee_image = db.Table(
    'weapon_melee_image', db.metadata,
    db.Column('weapon_melee_id', db.ForeignKey('weapon_melee.id', ondelete='RESTRICT',
                                               onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('weapon_melee_id', 'image_id')
)


class WeaponRanged(db.Model):
    __tablename__ = 'weapon_ranged'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'),
                         index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    fire_rate = db.Column(db.Float(53))
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)
    damage = db.Column(db.Numeric(3, 1), nullable=False)

    skill = db.relationship('Skill')
    images = db.relationship('Image', secondary='weapon_ranged_image')


t_weapon_ranged_image = db.Table(
    'weapon_ranged_image', db.metadata,
    db.Column('weapon_ranged_id', db.ForeignKey('weapon_ranged.id', ondelete='RESTRICT',
                                                onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'),
              nullable=False),
    db.UniqueConstraint('weapon_ranged_id', 'image_id')
)
