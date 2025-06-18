import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
} from 'typeorm';

export class CreateMedicalDataTable1749139828661 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'medical_data',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'patient_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'weight',
            type: 'float',
            isNullable: false,
          },
          {
            name: 'cycle',
            type: 'integer',
            isNullable: false,
          },
          {
            name: 'amg',
            type: 'float',
            isNullable: false,
          },
          {
            name: 'weight_gain',
            type: 'boolean',
            isNullable: false,
          },
          {
            name: 'hair_loss',
            type: 'boolean',
            isNullable: false,
          },
          {
            name: 'darkening_skin',
            type: 'boolean',
            isNullable: false,
          },
          {
            name: 'pimple',
            type: 'boolean',
            isNullable: false,
          },
          {
            name: 'fast_food',
            type: 'boolean',
            isNullable: false,
          },
          {
            name: 'left_follicles',
            type: 'int',
            isNullable: false,
          },
          {
            name: 'right_follicles',
            type: 'int',
            isNullable: false,
          },
          {
            name: 'created_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      })
    );

    await queryRunner.createForeignKey(
      'medical_data',
      new TableForeignKey({
        columnNames: ['patient_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'users',
        onDelete: 'CASCADE',
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('medical_data');
    if (table) {
      const foreignKey = table.foreignKeys.find(
        (fk) => fk.columnNames.indexOf('patient_id') !== -1
      );
      if (foreignKey) {
        await queryRunner.dropForeignKey('medical_data', foreignKey);
      }
    }
    await queryRunner.dropTable('medical_data');
  }
}
