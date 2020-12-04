# frozen_string_literal: true

module Sorting
  extend ActiveSupport::Concern

  def sort_and_paginate(collection)
    collection.sorts = build_sort_string if collection.sorts.empty?
    results = collection.result
    results.page(params[:currentPage]).per(params[:perPage] || 10)
  end

  private

  def build_sort_string
    "#{params[:sort_key]} #{params[:sort_dir]}"
  end
end
