module UsersHelper
  # Can be used to check ownership of items
  def is_author_of?(item)
    if @own_bookmarks && item.is_a?(Bookmark)
      @own_bookmarks.include?(item)
    elsif @own_works && item.is_a?(Work)
      @own_works.include?(item)
    else
      current_user.is_a?(User) && current_user.is_author_of?(item)
    end
  end

  # Can be used to check if user is maintainer of any collections
  def is_maintainer?
    current_user.is_a?(User) ? current_user.maintained_collections.present? : false
  end

  # Prints user pseuds with links to anchors for each pseud on the page and the description as the title
  def print_pseuds(user)
    user.pseuds.collect(&:name).join(', ')
  end

  # Determine which icon to show on user pages
  def standard_icon(pseud = nil)
    return "/images/skins/iconsets/default/icon_user.png" unless pseud&.icon&.attached?

    rails_blob_url(pseud.icon.variant(:standard))
  end

  # no alt text if there isn't specific alt text
  def icon_display(user = nil, pseud = nil)
    path = user ? (pseud ? user_pseud_path(pseud.user, pseud) : user_path(user)) : nil
    pseud ||= user.default_pseud if user
    icon = standard_icon(pseud)
    alt_text = pseud.try(:icon_alt_text) || nil

    if path
      link_to image_tag(icon, alt: alt_text, class: 'icon', skip_pipeline: true), path
    else
      image_tag(icon, class: 'icon', skip_pipeline: true)
    end
  end

  # Prints coauthors
  def print_coauthors(user)
    user.coauthors.collect(&:name).join(', ')
  end

  # Prints link to bookmarks page with user-appropriate number of bookmarks
  # (The total should reflect the number of bookmarks the user can actually see.)
  def bookmarks_link(user, pseud = nil)
    return pseud_bookmarks_link(pseud) if pseud.present? && !pseud.new_record?

    total = SearchCounts.bookmark_count_for_user(user)
    span_if_current ts('Bookmarks (%{bookmark_number})', bookmark_number: total.to_s), user_bookmarks_path(@user)
  end

  def pseud_bookmarks_link(pseud)
    total = SearchCounts.bookmark_count_for_pseud(pseud)
    span_if_current ts('Bookmarks (%{bookmark_number})', bookmark_number: total.to_s), user_pseud_bookmarks_path(@user, pseud)
  end

  # Prints link to works page with user-appropriate number of works
  # (The total should reflect the number of works the user can actually see.)
  def works_link(user, pseud = nil)
    return pseud_works_link(pseud) if pseud.present? && !pseud.new_record?

    total = SearchCounts.work_count_for_user(user)
    span_if_current ts('Works (%{works_number})', works_number: total.to_s), user_works_path(@user)
  end

  def pseud_works_link(pseud)
    total = SearchCounts.work_count_for_pseud(pseud)
    span_if_current ts('Works (%{works_number})', works_number: total.to_s), user_pseud_works_path(@user, pseud)
  end

  # Prints link to series page with user-appropriate number of series
  def series_link(user, pseud = nil)
    return pseud_series_link(pseud) if pseud.present? && !pseud.new_record?

    total = if current_user.nil?
              Series.visible_to_all.exclude_anonymous.for_user(user).count.size
            else
              Series.visible_to_registered_user.exclude_anonymous.for_user(user).count.size
            end
    span_if_current ts("Series (%{series_number})", series_number: total.to_s), user_series_index_path(user)
  end

  def pseud_series_link(pseud)
    total = if current_user.nil?
              Series.visible_to_all.exclude_anonymous.for_pseud(pseud).count.size
            else
              Series.visible_to_registered_user.exclude_anonymous.for_pseud(pseud).count.size
            end
    span_if_current ts("Series (%{series_number})", series_number: total.to_s), user_pseud_series_index_path(pseud.user, pseud)
  end

  def gifts_link(user)
    if current_user.nil?
      gift_number = user.gift_works.visible_to_all.distinct.count
    else
      gift_number = user.gift_works.visible_to_registered_user.distinct.count
    end
    span_if_current ts('Gifts (%{gift_number})', gift_number: gift_number.to_s), user_gifts_path(user)
  end

  def authored_items(pseud, work_counts = {}, rec_counts = {})
    visible_works = pseud.respond_to?(:work_count) ? pseud.work_count.to_i : (work_counts[pseud.id] || 0)
    visible_recs = pseud.respond_to?(:rec_count) ? pseud.rec_count.to_i : (rec_counts[pseud.id] || 0)
    items = visible_works == 1 ? link_to(visible_works.to_s + ' work', user_pseud_works_path(pseud.user, pseud)) : (visible_works > 1 ? link_to(visible_works.to_s + ' works', user_pseud_works_path(pseud.user, pseud)) : '')
    items += ', ' if (visible_works > 0) && (visible_recs > 0)
    if visible_recs > 0
      items += visible_recs == 1 ? link_to(visible_recs.to_s + ' rec', user_pseud_bookmarks_path(pseud.user, pseud, recs_only: true)) : link_to(visible_recs.to_s + ' recs', user_pseud_bookmarks_path(pseud.user, pseud, recs_only: true))
    end
    items.html_safe
  end

  def log_item_action_name(item)
    action = item.action
    
    return fnok_action_name(item) if fnok_action?(action)

    case action
    when ArchiveConfig.ACTION_ACTIVATE
      t("users_helper.log.validated")
    when ArchiveConfig.ACTION_ADD_ROLE
      t("users_helper.log.role_added")
    when ArchiveConfig.ACTION_REMOVE_ROLE
      t("users_helper.log.role_removed")
    when ArchiveConfig.ACTION_SUSPEND
      t("users_helper.log.suspended")
    when ArchiveConfig.ACTION_UNSUSPEND
      t("users_helper.log.lift_suspension")
    when ArchiveConfig.ACTION_BAN
      t("users_helper.log.ban")
    when ArchiveConfig.ACTION_WARN
      t("users_helper.log.warn")
    when ArchiveConfig.ACTION_RENAME
      t("users_helper.log.rename")
    when ArchiveConfig.ACTION_PASSWORD_CHANGE
      t("users_helper.log.password_change")
    when ArchiveConfig.ACTION_NEW_EMAIL
      t("users_helper.log.email_change")
    when ArchiveConfig.ACTION_TROUBLESHOOT
      t("users_helper.log.troubleshot")
    when ArchiveConfig.ACTION_NOTE
      t("users_helper.log.note")
    when ArchiveConfig.ACTION_PASSWORD_RESET
      t("users_helper.log.password_reset")
    end
  end

  # Give the TOS field in the new user form a different name in non-production environments
  # so that it can be filtered out of the log, for ease of debugging
  def tos_field_name
    if Rails.env.production?
      'terms_of_service'
    else
      'terms_of_service_non_production'
    end
  end

  private

  def fnok_action?(action)
    [
      ArchiveConfig.ACTION_ADD_FNOK,
      ArchiveConfig.ACTION_REMOVE_FNOK,
      ArchiveConfig.ACTION_ADDED_AS_FNOK,
      ArchiveConfig.ACTION_REMOVED_AS_FNOK
    ].include?(action)
  end

  def fnok_action_name(item)
    action_leaf =
      case item.action
      when ArchiveConfig.ACTION_ADD_FNOK
        "has_added"
      when ArchiveConfig.ACTION_REMOVE_FNOK
        "has_removed"
      when ArchiveConfig.ACTION_ADDED_AS_FNOK
        "was_added"
      when ArchiveConfig.ACTION_REMOVED_AS_FNOK
        "was_removed"
      end

    t(
      "users_helper.log.fnok.#{action_leaf}",
      user_id: item.fnok_user_id
    )
  end
end
