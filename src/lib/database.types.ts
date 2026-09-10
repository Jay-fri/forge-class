// Hand-written to match the migrations under supabase/migrations/, through
// 20260910080000_phase3_lesson_experience.sql.
// Regenerate with `supabase gen types typescript --linked` once Docker/CLI
// access to this project is available, and this file can be replaced.

export type UserRole = 'student' | 'instructor'
export type ApprovalStatus = 'pending' | 'approved' | 'rejected'
export type ContentDropMode = 'weekly' | 'all_at_once'
export type CohortStatus = 'upcoming' | 'active' | 'completed'
export type LateJoinDecision = 'waitlist' | 'allow' | 'allow_with_fee'
export type TrackLevel = 'beginner' | 'intermediate' | 'advanced'
export type ProgressStatus = 'not_started' | 'in_progress' | 'completed'
export type ContentFeedbackType = 'confusing' | 'typo'
export type ContentFeedbackStatus = 'open' | 'resolved'

export interface Database {
  public: {
    Tables: {
      bundles: {
        Row: {
          id: string
          name: string
          slug: string
          description: string | null
          audience: string | null
          price: number
          currency: string
          is_active: boolean
          whatsapp_group_link: string | null
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['bundles']['Row']> & {
          name: string
          slug: string
        }
        Update: Partial<Database['public']['Tables']['bundles']['Row']>
        Relationships: []
      }
      profiles: {
        Row: {
          id: string
          email: string
          full_name: string | null
          role: UserRole
          approval_status: ApprovalStatus
          assigned_bundle_id: string | null
          whatsapp_group_invited_at: string | null
          welcome_video_watched_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['profiles']['Row']> & {
          id: string
          email: string
        }
        Update: Partial<Database['public']['Tables']['profiles']['Row']>
        Relationships: []
      }
      cohorts: {
        Row: {
          id: string
          bundle_id: string
          name: string
          start_date: string
          end_date: string
          content_drop_mode: ContentDropMode
          status: CohortStatus
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['cohorts']['Row']> & {
          bundle_id: string
          name: string
          start_date: string
          end_date: string
        }
        Update: Partial<Database['public']['Tables']['cohorts']['Row']>
        Relationships: []
      }
      cohort_memberships: {
        Row: {
          id: string
          student_id: string
          cohort_id: string
          bundle_id: string
          is_late_join: boolean
          late_join_decision: LateJoinDecision | null
          late_fee: number | null
          joined_at: string
        }
        Insert: Partial<Database['public']['Tables']['cohort_memberships']['Row']> & {
          student_id: string
          cohort_id: string
          bundle_id: string
        }
        Update: Partial<Database['public']['Tables']['cohort_memberships']['Row']>
        Relationships: []
      }
      tracks: {
        Row: {
          id: string
          name: string
          slug: string
          level: TrackLevel
          description: string | null
          order_index: number
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['tracks']['Row']> & {
          name: string
          slug: string
        }
        Update: Partial<Database['public']['Tables']['tracks']['Row']>
        Relationships: []
      }
      bundle_tracks: {
        Row: {
          bundle_id: string
          track_id: string
        }
        Insert: Database['public']['Tables']['bundle_tracks']['Row']
        Update: Partial<Database['public']['Tables']['bundle_tracks']['Row']>
        Relationships: []
      }
      modules: {
        Row: {
          id: string
          track_id: string
          name: string
          slug: string
          order_index: number
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['modules']['Row']> & {
          track_id: string
          name: string
          slug: string
        }
        Update: Partial<Database['public']['Tables']['modules']['Row']>
        Relationships: []
      }
      lessons: {
        Row: {
          id: string
          module_id: string
          title: string
          slug: string
          order_index: number
          is_free_preview: boolean
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['lessons']['Row']> & {
          module_id: string
          title: string
          slug: string
        }
        Update: Partial<Database['public']['Tables']['lessons']['Row']>
        Relationships: []
      }
      sections: {
        Row: {
          id: string
          lesson_id: string
          title: string | null
          content: string | null
          order_index: number
          sandbox_template: string | null
          sandbox_files: Record<string, string> | null
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['sections']['Row']> & {
          lesson_id: string
        }
        Update: Partial<Database['public']['Tables']['sections']['Row']>
        Relationships: []
      }
      section_quizzes: {
        Row: {
          id: string
          section_id: string
          question: string
          options: string[]
          correct_index: number
          explanation: string | null
          order_index: number
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['section_quizzes']['Row']> & {
          section_id: string
          question: string
          options: string[]
          correct_index: number
        }
        Update: Partial<Database['public']['Tables']['section_quizzes']['Row']>
        Relationships: []
      }
      content_feedback: {
        Row: {
          id: string
          section_id: string
          user_id: string
          feedback_type: ContentFeedbackType
          note: string | null
          status: ContentFeedbackStatus
          created_at: string
        }
        Insert: Partial<Database['public']['Tables']['content_feedback']['Row']> & {
          section_id: string
          user_id: string
          feedback_type: ContentFeedbackType
        }
        Update: Partial<Database['public']['Tables']['content_feedback']['Row']>
        Relationships: []
      }
      ai_usage: {
        Row: {
          user_id: string
          usage_date: string
          count: number
        }
        Insert: Partial<Database['public']['Tables']['ai_usage']['Row']> & {
          user_id: string
        }
        Update: Partial<Database['public']['Tables']['ai_usage']['Row']>
        Relationships: []
      }
      user_progress: {
        Row: {
          id: string
          user_id: string
          section_id: string
          status: ProgressStatus
          completed_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['user_progress']['Row']> & {
          user_id: string
          section_id: string
        }
        Update: Partial<Database['public']['Tables']['user_progress']['Row']>
        Relationships: []
      }
      streaks: {
        Row: {
          user_id: string
          current_streak: number
          longest_streak: number
          last_active_date: string | null
          updated_at: string
        }
        Insert: Partial<Database['public']['Tables']['streaks']['Row']> & {
          user_id: string
        }
        Update: Partial<Database['public']['Tables']['streaks']['Row']>
        Relationships: []
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
    CompositeTypes: Record<string, never>
  }
}
