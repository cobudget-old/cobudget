class CreateInitialDb < ActiveRecord::Migration
  def change
    create_table :people do |t|
    end

    create_table :buckets do |t|
    end

    create_table :budgets do |t|
    end

    create_table :reserve_buckets do |t|
      t.integer :bucket_id
      t.integer :budget_id
      t.integer :allocator_id
    end

    create_table :allocators do |t|
      t.integer :person_id
      t.integer :budget_id
    end

    create_table :rounds do |t|
    end

    create_table :projects do |t|
      t.integer :budget_id
      t.integer :sponsor_id
      t.string  :name
      t.text    :description
      t.integer :min_cents
      t.integer :target_cents
      t.integer :max_cents
    end

    create_table :round_projects do |t|
      t.integer :project_id
      t.integer :round_id
      t.integer :bucket_id
    end

    create_table :allocation_rights do |t|
      t.integer :allocator_id
      t.integer :round_id
      t.integer :amount_cents
    end

    create_table :allocations do |t|
      t.integer :allocator_id
      t.integer :bucket_id
      t.integer :amount_cents
    end

    add_foreign_key :reserve_buckets, :buckets
    add_foreign_key :reserve_buckets, :budgets
    add_foreign_key :reserve_buckets, :allocators
    add_foreign_key :round_projects, :projects
    add_foreign_key :round_projects, :rounds
    add_foreign_key :round_projects, :buckets
    add_foreign_key :projects, :budgets
    add_foreign_key :projects, :people, column: :sponsor_id
    add_foreign_key :allocators, :people
    add_foreign_key :allocators, :budgets
    add_foreign_key :allocation_rights, :allocators
    add_foreign_key :allocation_rights, :rounds
    add_foreign_key :allocations, :allocators
    add_foreign_key :allocations, :buckets
  end
end
